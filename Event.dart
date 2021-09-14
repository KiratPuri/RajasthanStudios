import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class Event extends Equatable{}

class FetchEvent extends Event {

  late int length;
  FetchEvent({required this.length});

  get len {return this.length;}
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialFetch extends Event {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
