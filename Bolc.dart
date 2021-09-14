import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rajasthanstudio/Data/Model.dart';
import 'package:rajasthanstudio/Data/Repo.dart';
import 'Event.dart';
import 'State.dart';

class CoursesBloc extends Bloc<Event, BlocState> {

  RepositoryImpl repository;
  late List<Photos> photos;

  CoursesBloc({required this.repository}) : super(InitialState());

  @override
  // TODO: implement initialState
  BlocState get initialState => InitialState();

  @override
  Stream<BlocState> mapEventToState(Event event) async* {
    if(event is InitialFetch){
      print("Bloc Started..................................");
      yield InitialState();
      photos = await repository.getPhotos(15);
      print(photos.length);
      yield LoadedState(photos: photos);
    }
    if (event is FetchEvent) {
      print(event.len);
      yield LoadingState();
      photos = await repository.getPhotos(event.len);
      print("//////////////////////////////////////////////");
      print(photos.length);
      yield LoadedState(photos: photos);
    }
  }
}
