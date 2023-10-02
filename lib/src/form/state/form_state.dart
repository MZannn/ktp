part of 'form_cubit.dart';

@immutable
sealed class FormVisitorState extends Equatable {
  const FormVisitorState();

  @override
  List<Object> get props => [];
}

final class FormInitial extends FormVisitorState {}

final class FormLoading extends FormVisitorState {}

final class TextRecognized extends FormVisitorState {
  final String identityNumber;
  final String name;
  final String address;
  final File? image;

  const TextRecognized(
      this.identityNumber, this.name, this.address, this.image);

  @override
  List<Object> get props => [identityNumber, name];
}

final class TextRecognizedSuccess extends FormVisitorState {
  final String? identityNumber;
  final String? name;
  final String? address;
  final String? vilages;
  final String? districts;
  final File? image;
  final NIKModel? nikModel;
  const TextRecognizedSuccess({
    this.name,
    this.identityNumber,
    this.address,
    this.image,
    this.vilages,
    this.districts,
    this.nikModel,
  });
  @override
  List<Object> get props => [
        name!,
        identityNumber!,
        address!,
        image!,
        vilages!,
        districts!,
        nikModel!
      ];
}

final class FormVisitorSuccess extends FormVisitorState {
  final String message;
  const FormVisitorSuccess(this.message);
  @override
  List<Object> get props => [message];
}

final class FormVisitorError extends FormVisitorState {
  final String message;
  const FormVisitorError(this.message);
  @override
  List<Object> get props => [message];
}
