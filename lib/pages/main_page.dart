import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
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
    return Stack(
      children: [
        MainPageStateWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
          child: SearchWidget(),
        )
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();
   bool controllerEmpty = false;




  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener((){
        bloc.updateText(controller.text);
        if (controller.text != '') {
          setState(() {
            controllerEmpty = true;
          });
        }
        else{
          setState(() {
            controllerEmpty = false;
          });
        }
      });
     // print( 'New' + controller.text);

    });
  }

  @override
  Widget build(BuildContext context) {
   // final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return TextField(
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.words,
      // каждая буква слова с большой буквы
      cursorColor: Colors.white,
      // цвет курсора
      controller: controller,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: SuperheroesColors.white),
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: SuperheroesColors.indigo75,
          prefixIcon:
              Icon(Icons.search, color: SuperheroesColors.white54, size: 24),
          suffix: GestureDetector(
              child:
                  Icon(Icons.close, color: SuperheroesColors.white, size: 24),
              onTap: (){ controller.clear();
              setState(() {
                controllerEmpty = false;
              });
              }),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

          focusedBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: SuperheroesColors.white, width: 2)),
          enabledBorder: controllerEmpty == true ?
          OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: SuperheroesColors.white, width: 2))
          :  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: SuperheroesColors.white24)),


            ),





    );
  }




}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.noFavorites:
            return Stack(
              children: [
                NoFavoritesWidget(),
                Align(alignment: Alignment.bottomCenter,
                    child: ActionButton(text: 'Remove', onTap: bloc.removeFavorite))
              ],
            );
          case MainPageState.minSymbols:
            return MinSymbolsWidget();
          case MainPageState.loading:
            return LoadingIndicator();
          case MainPageState.nothingFound:
            return NothingFoundWidget();
          case MainPageState.loadingError:
            return LoadingErrorWidget();
          case MainPageState.searchResults:
            return SuperheroesList(
              title: 'Search resulrs',
              stream: bloc.observeSearcedSuperherose(),
            );
          case MainPageState.favorites:
            return Stack(
              children: [
                SuperheroesList(
                  title: 'Your fovorits',
                  stream: bloc.observeFavoriteSuperherose(),
                ),
                Align(alignment: Alignment.bottomCenter,
                    child: ActionButton(text: 'Remove', onTap: bloc.removeFavorite))
              ],
            );
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

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperheroesList({
    Key? key,
    required this.title,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final List<SuperheroInfo> superheroes = snapshot.data!;
          return ListView.separated(
            itemCount: superheroes.length + 1,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                      right: 16, left: 16, top: 90, bottom: 12),
                  child: Text(title,
                      style: TextStyle(
                          color: SuperheroesColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.start),
                );
              }
              final SuperheroInfo item = superheroes[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SuperheroCard(
                    superheroInfo: item,
                    //  superheroInfo: item.,
                    // name: item.name,
                    //  realName: item.realName,
                    //  imageUrl: item.imageUrl,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SuperheroPage(name: item.name),
                      ));
                    }),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
            },
          );
        });
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
