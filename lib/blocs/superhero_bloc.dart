import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final superheroSubject = BehaviorSubject<Superhero>();

final superheroPageState = BehaviorSubject<SuperheroPageState>();


  StreamSubscription? requestSubscription;
  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  SuperheroBloc({this.client, required this.id}) {
    getFromFavorites();
  }

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperheroesStorage.getInstance()
        .getSuperhiro(id)
        .asStream()
        .listen((superhero) {
      if (superhero != null) {
        superheroSubject.add(superhero);
        superheroPageState.add(SuperheroPageState.loaded);
      }
      else{
        superheroPageState.add(SuperheroPageState.loading);
      }

      requestSuperhero(superhero != null);
    },
            onError: (error, stackTace) => print(
                'Error happened in requestSuperhero: $error, $stackTace'));
  }

  void addToFavorite() {
    final superhero = superheroSubject.valueOrNull;
    if (superhero == null) {
      print("Error: superhero is null while shouldn't be");
      return;
    }

    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen((event) {
      print('Added to favorites: $event');
    },
            onError: (error, stackTace) => print(
                'Error happened in requestSuperhero: $error, $stackTace'));
  }

  void removeFromFavorites() {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen((event) {
      print('Remove from favorites: $event');
    },
            onError: (error, stackTace) => print(
                'Error happened in requestSuperhero: $error, $stackTace'));
  }

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  void requestSuperhero( final bool isInFavorites) {
    requestSubscription?.cancel();

    requestSubscription = request().asStream().listen((superhero) {
      superheroSubject.add(superhero);
      superheroPageState.add(SuperheroPageState.loaded);
    }, onError: (error, stackTrace) {
      if(!isInFavorites){
        superheroPageState.add(SuperheroPageState.error);
      }
      print('Error happend in requestSuperhero: $error, $StackTrace');
    });
  }

  Future<Superhero> request() async {
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response = await (client ??= http.Client())
        .get(Uri.parse('https://superheroapi.com/api/$token/$id'));
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happend');
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happend');
    }

    final decoded = json.decode(response.body);
    if (decoded['response'] == 'success') {
      return Superhero.fromJson(decoded);
    } else if (decoded['response'] == 'error') {
      throw ApiException('Client error happend');
    }

    throw Exception('UnKnown error happend');
  }

  Stream<Superhero> observeSuperhero() => superheroSubject;
  Stream<SuperheroPageState> observeSuperheroPageState() => superheroPageState.distinct();

  void dispose() {
    client?.close();
    getFromFavoritesSubscription?.cancel();
    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    superheroPageState.close();
    superheroSubject.close();
  }


}

enum SuperheroPageState {
  loading,
  loaded,
  error,
}
