import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../widgets/action_button.dart';
import 'superhero_page.dart';

class MainPage extends StatefulWidget {
  final http.Client? client;

  MainPage({Key? key, this.client}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = MainBloc(client: widget.client);
  }

  late MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
          backgroundColor: SuperheroesColors.background,
          body: SafeArea(
            child: MainPageContent(),
          )),
    );
  }

  @override
  void dispose() {
    bloc.dispose(); // TODO: implement dispose
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusNode focusTextField = FocusNode();
    return Stack(
      children: [
        MainPageStateWidget(focusTextField: focusTextField),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SearchWidget(focusTextField: focusTextField),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  final FocusNode focusTextField;

  SearchWidget({
    Key? key,
    required this.focusTextField,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();
  bool focus = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of(context, listen: false);
      controller.addListener(() {
        bloc.updateText(controller.text);
        if (controller.text.isEmpty) {
          setState(() {
            focus = false;
          });
        } else {
          setState(() {
            focus = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusTextField,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.words,
      controller: controller,
      cursorColor: SuperheroesColors.white,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: SuperheroesColors.white),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: SuperheroesColors.white54),
        isDense: true,
        filled: true,
        fillColor: SuperheroesColors.indigo75,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: SuperheroesColors.white, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: focus
                ? BorderSide(color: SuperheroesColors.white, width: 2)
                : BorderSide(color: SuperheroesColors.white24)),
        suffix: GestureDetector(
            onTap: () => controller.clear(),
            child: const Icon(
              Icons.close,
              color: SuperheroesColors.white54,
            )),
        prefixIcon: const Icon(
          Icons.search,
          color: SuperheroesColors.white54,
          size: 24,
        ),
      ),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  final FocusNode focusTextField;

  MainPageStateWidget({
    Key? key,
    required this.focusTextField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<MainPageState>(
        stream: bloc.observeMainPageState(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }

          final MainPageState state = snapshot.data!;

          switch (state) {
            case MainPageState.loading:
              return LoadingIndicator();

            case MainPageState.minSymbols:
              return minSymbols();

            case MainPageState.noFavorites:
              return Stack(
                children: [
                  noFavorites(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ActionButton(
                      text: "Search",
                      onTap: () {
                        focusTextField.requestFocus();
                      },
                    ),
                  )
                ],
              );

            case MainPageState.favorites:
              return Stack(
                children: [
                  SuperheroesList(
                    stream: bloc.observeFavoriteSuperherose(),
                    title: 'Your favorites',
                    ableToSwipe: true,
                  ),
                ],
              );

            case MainPageState.searchResults:
              return SuperheroesList(
                stream: bloc.observeSearcedSuperherose(),
                title: 'Search results',
                ableToSwipe: false,
              );

            case MainPageState.nothingFound:
              return Center(
                child: InfoWithButton(
                  buttonText: 'Serch',
                  title: 'Nothing found',
                  subtitle: 'Search for something else',
                  imageHeight: 112,
                  imageWidth: 84,
                  imageTopPadding: 16,
                  assetImage: SuperheroesImages.halk,
                  onTap: () {
                    focusTextField.requestFocus();
                  },
                ),
              );

            case MainPageState.loadingError:
              return Center(
                child: InfoWithButton(
                  buttonText: 'Retry',
                  title: 'Error happened',
                  subtitle: 'Please, try again',
                  imageHeight: 126,
                  imageWidth: 106,
                  imageTopPadding: 22,
                  assetImage: SuperheroesImages.superman,
                  onTap: () {
                    bloc.retry();
                  },
                ),
              );

            default:
              return Center(
                  child: Text(
                    state.toString(),
                    style: TextStyle(color: SuperheroesColors.white),
                  ));
          }
        }));
  }
}
class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;
  final bool ableToSwipe;

  const SuperheroesList({Key? key, required this.title, required this.stream, required this.ableToSwipe})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox.shrink();
        }
        final List<SuperheroInfo> superheroes = snapshot.data!;
        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: superheroes.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTitleWidget(title: title);
            } else {
              final item = superheroes[index - 1];
              return ListTile(superhero: item, ableToSwipe: ableToSwipe,);
            }
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 8,
            );
          },
        );
      },
    );
  }
}

class ListTile extends StatelessWidget {
  final SuperheroInfo superhero;
  final bool ableToSwipe;
  const ListTile({
    Key? key,
    required this.superhero,
    required this.ableToSwipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    final card = SuperheroCard(
        superheroeinfo: superhero,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SuperheroPage(id: superhero.id)));
        });
    if(ableToSwipe){

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Dismissible(

          key: ValueKey(superhero.id),
          child: card,
          background: BackgroundCard(isLeft: true),
          secondaryBackground: BackgroundCard(isLeft: false),
          onDismissed: (_) {
            bloc.removeFromFavorites(superhero.id);
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: card,
    );
  }
}


class BackgroundCard extends StatelessWidget {
  final bool isLeft;
  const BackgroundCard({Key? key, required this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      height: 70,
      alignment: isLeft? Alignment.centerLeft: Alignment.centerRight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperheroesColors.red),
      child: Text(
        "Remove\nfrom\nfavorites".toUpperCase(),
        textAlign: isLeft? TextAlign.left: TextAlign.right,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}


class ListTitleWidget extends StatelessWidget {
  const ListTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 90),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: SuperheroesColors.white),
      ),
    );
  }
}

class minSymbols extends StatelessWidget {
  const minSymbols({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 134),
      child: Align(
        child: Text(
          'Enter at least 3 symbols',
          style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 134),
      child: Align(
        child: CircularProgressIndicator(
            strokeWidth: 4, color: SuperheroesColors.circulColor),
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class noFavorites extends StatelessWidget {
  const noFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Center(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SuperheroesColors.buttonBackgroundColor),
                  width: 108,
                  height: 108,
                )),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Image(
                  image: AssetImage(SuperheroesImages.ironman),
                  width: 108,
                  height: 119,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 40),
        Text(
          "No favorites yet",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: SuperheroesColors.white),
        ),
        SizedBox(height: 20),
        Text(
          "Search and add".toUpperCase(),
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SuperheroesColors.white),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
