// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:equatable/equatable.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ktp/env/class/env.dart';
import 'package:meta/meta.dart';
import 'package:nik_validator/nik_validator.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
part 'form_state.dart';

class FormCubit extends Cubit<FormVisitorState> {
  FormCubit() : super(FormInitial());
  RecognizedText recognizedText = RecognizedText(
    text: '',
    blocks: [],
  );
  TextRecognizer textRecognizer = TextRecognizer();
  String nik = '';
  String name = '';
  String address = '';

  Future<void> scanImage() async {
    nik = '';
    name = '';
    address = '';
    NIKModel? nikModel;
    try {
      emit(FormInitial());
      File? croppedFile;
      final pictureFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (pictureFile != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: pictureFile.path,
          aspectRatio: const CropAspectRatio(
            ratioX: 3,
            ratioY: 2,
          ),
        );
        if (croppedImage != null) {
          emit(
            TextRecognized(
              '',
              '',
              '',
              File(croppedImage.path),
            ),
          );
          emit(FormInitial());
          croppedFile = File(croppedImage.path);
          final croppedInputImage = InputImage.fromFile(croppedFile);
          recognizedText = await textRecognizer.processImage(croppedInputImage);
          extractDataFromText(recognizedText);
        } else {
          final file = File(pictureFile.path);
          final inputImage = InputImage.fromFile(file);
          recognizedText = await textRecognizer.processImage(inputImage);
          extractDataFromText(recognizedText);
        }

        emit(
          TextRecognizedSuccess(
            address: address,
            identityNumber: nik,
            name: name,
            image: croppedFile ?? File(pictureFile.path),
            vilages: null,
            districts: null,
            nikModel: nikModel,
          ),
        );
      } else {
        emit(
          const TextRecognizedSuccess(
            address: null,
            identityNumber: null,
            name: null,
            image: null,
            vilages: null,
            districts: null,
            nikModel: null,
          ),
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void extractDataFromText(RecognizedText recognizedText) async {
    bool foundNIK = false;
    bool foundName = false;
    try {
      outerloop:
      for (int i = 0; i < recognizedText.blocks.length; i++) {
        for (int j = 0; j < recognizedText.blocks[i].lines.length; j++) {
          var data = recognizedText.blocks[i].lines[j].text;

          if (foundNIK && foundName && isAddress(data)) {
            address = data.replaceAll(':', '').replaceAll('Alamat', '');
            break outerloop;
          } else if (foundNIK && !foundName) {
            name = data
                .replaceAll(':', '')
                .replaceAll('Nama', '')
                .replaceAll('NIK', '')
                .replaceAll('Alamat', '')
                .replaceAll('Pekerjaan', '')
                .replaceAll('Berlaku Hingga', '')
                .replaceAll('Agama', '')
                .replaceAll('Jenis Kelamin', '')
                .replaceAll('KelDesa', '')
                .replaceAll('Kewarganegaraan', '')
                .replaceAll('Status Perkawinan', '')
                .replaceAll('Kel/Desa', '');
            foundName = true;
          } else if (!foundNIK &&
              isNIK(recognizedText.blocks[i].lines[j].text)) {
            nik = data
                .replaceAll('NIK', '')
                .replaceAll(' ', '')
                .replaceAll(':', '')
                .replaceAll('J', '1')
                .replaceAll('U', '0')
                .replaceAll('?', '7')
                .replaceAll('l', '1')
                .replaceAll('L', '1')
                .replaceAll('I', '1')
                .replaceAll('O', '0')
                .replaceAll('B', '8')
                .replaceAll('b', '6')
                .replaceAll('D', '0')
                .replaceAll('S', '5');
            foundNIK = true;
          }
          parse(nik);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NIKModel?>? parse(String text) async {
    NIKModel result = await NIKValidator.instance.parse(nik: text);
    if (result.valid == true) {
      print(result.subdistrict);
      return result;
    }
    return null;
  }

  bool isNIK(String text) {
    const nikPattern = r'\d{10,16}';
    final nikRegex = RegExp(nikPattern);
    return nikRegex.hasMatch(text);
  }

  bool isAddress(String text) {
    const addressPattern = r'^JL';
    final addressRegex = RegExp(addressPattern);
    return addressRegex.hasMatch(text);
  }

  onBloc() {
    emit(const TextRecognizedSuccess());
  }

  sendVisitorData({
    required String nik,
    required String name,
    required String address,
    required String phoneNumber,
    required String familyCardNumber,
    required String village,
    required String subdistrict,
    required File image,
  }) async {
    emit(FormLoading());
    try {
      SharedPreferences storage = await SharedPreferences.getInstance();
      int? userId = storage.getInt('userId');
      print(userId);
      Response response = await KTPApi().post(
        path: 'send-visitor-data',
        formdata: FormData.fromMap(
          {
            'identity_number': nik,
            'name': name,
            'address': address,
            'phone_number': phoneNumber,
            'family_card_number': familyCardNumber,
            'photo': await MultipartFile.fromFile(
              image.path,
              filename: basename(image.path),
            ),
            'village': village,
            'subdistrict': subdistrict,
            'created_by': userId,
          },
        ),
      );
      print(response.data);
      nik = '';
      name = '';
      address = '';
      phoneNumber = '';
      familyCardNumber = '';
      village = '';
      subdistrict = '';
      if (response.statusCode == 200) {
        emit(
          FormVisitorSuccess(
            response.data['message'],
          ),
        );
      }
      emit(
        TextRecognizedSuccess(
          identityNumber: nik,
          name: name,
          address: address,
          image: null,
          vilages: village,
          districts: subdistrict,
          nikModel: null,
        ),
      );
    } catch (e) {
      emit(
        FormVisitorError(
          e.toString(),
        ),
      );
    }
  }
}
