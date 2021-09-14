import 'package:equatable/equatable.dart';
import 'package:rajasthanstudio/Data/Model.dart';

abstract class BlocState extends Equatable {}

class InitialState extends BlocState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingState extends BlocState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadedState extends BlocState {

  List<Photos> photos;

  LoadedState({required this.photos});

  @override
  // TODO: implement props
  List<Object> get props => [photos];
}

class ErrorState extends BlocState {

  String message;

  ErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}