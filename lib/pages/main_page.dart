import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return Stack(
      children: [
        MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child:
              ActionButton(text: 'Next state', onTap: () => bloc.nextState()),
        )
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.noFavorites:
            return NoFavoritesWidget();
          case MainPageState.minSymbols:
            return MinSymbolsWidget();
          case MainPageState.loading:
            return LoadingIndicator();
          case MainPageState.nothingFound:
            return NothingFoundWidget();
          case MainPageState.loadingError:
            return LoadingErrorWidget();
          case MainPageState.searchResults:
            return SearchResultsWidget();
          case MainPageState.favorites:
            return FavoritesWidget();
          default:
            return Center(
                child: Text(
              state.toString(),
              style: TextStyle(color: Colors.white),
            ));
        }
      },
    );
  }
}


class NoFavoritesWidget extends StatelessWidget {
  const NoFavoritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'No favorites yet',
      subtitle: 'Search and add',
      assetImage: SuperheroesImages.ironman,
      buttonText: 'Search',
      imageTopPadding: 9,
      imageHeight: 119,
      imageWidth: 108,
    );
  }
}

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InfoWithButton(
        title: 'Error happened',
        subtitle: 'Please, try again',
        assetImage: SuperheroesImages.superman,
        buttonText: 'Retry',
        imageTopPadding: 22,
        imageHeight: 106,
        imageWidth: 126,
      ),
    );
  }
}


class NothingFoundWidget extends StatelessWidget {
  const NothingFoundWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'Nothing found',
      subtitle: 'Search for something else',
      assetImage: SuperheroesImages.halk,
      buttonText: 'Search',
      imageTopPadding: 16,
      imageHeight: 112,
      imageWidth: 84,
    );
  }
}

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Search results',
              style: TextStyle(
                  color: SuperheroesColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.start),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
              name: "Batman",
              realName: 'Bruce Wayne',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuperheroPage(name: 'Batman'),
                ));
              }),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
              name: "Venom",
              realName: 'Eddie Brock',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuperheroPage(name: 'Venom'),
                ));
              }),
        )
      ],
    );
  }
}

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Your favorites',
              style: TextStyle(
                  color: SuperheroesColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.start),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
              name: "Batman",
              realName: 'Bruce Wayne',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuperheroPage(name: 'Batman'),
                ));
              }),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
              name: "Ironman",
              realName: 'Tony Stark',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuperheroPage(name: 'Ironman'),
                ));
              }),
        )
      ],
    );
  }
}





class MinSymbolsWidget extends StatelessWidget {
  const MinSymbolsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 110),
          child: Text(
            'Enter at least 3 symbols',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
            color: SuperheroesColors.blue, strokeWidth: 4),
      ),
    );
  }
}
