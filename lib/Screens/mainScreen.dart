import 'package:flutter/material.dart';
import 'package:cats_gallery/api.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<String> Images = [];
  late Future? promise;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    promise = fetchData();
    super.initState();

    scrollController.addListener(() {
      // print(' ${scrollController.position.pixels}, ${scrollController.position.maxScrollExtent} ');
      if ((scrollController.position.pixels + 500) >=
          scrollController.position.maxScrollExtent) {
        // add5();
        fetchData();
      }
    });
  }

  Future<String> fetchData() async {
    if (isLoading) return "";

    isLoading = true;
    setState(() {});

    await Future.delayed(const Duration(seconds: 3));
    //Images.add(
    //    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/David_Gilmour_and_stratocaster.jpg/220px-David_Gilmour_and_stratocaster.jpg");
    add5();

    isLoading = false;
    setState(() {});

    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) return "";

    scrollController.animateTo(scrollController.position.pixels + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
    return "";
  }

  void add5() async {
    for (int i = 0; i < 5; i++) {
      Images.add(await Api().getCat());
    }
    setState(() {});
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 3));
    Images.clear();
    add5();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RefreshIndicator(
            color: Colors.indigo,
            onRefresh: onRefresh,
            child: FutureBuilder(
              future: promise,
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.done) {
                /*return Column(
                  children: [
                    for (int i = 0; i < Images.length; i++)*/
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: Images.length,
                  itemBuilder: (BuildContext context, int i) {
                    return FadeInImage(
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                      placeholder: const AssetImage('assets/jar-loading.gif'),
                      //image: NetworkImage(
                      //   'https://picsum.photos/500/300?image=1'),
                      image: NetworkImage(Images[i]),
                    );
                  },
                );
                /* } else {
                    return Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(vertical: 390),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.indigo,
                        color: Colors.indigo[200],
                      ),
                    );
                  }*/

                //   }
              },
            ),
          ),
          if (isLoading)
            Positioned(
                bottom: 40,
                left: size.width * 0.5 - 30,
                child: const _LoadingIcon())
        ],
      ),
    );
  }
}

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
        child: const CircularProgressIndicator(color: Colors.indigo));
  }
}
/* List<Map<String, dynamic>> cats = [];

  void getCats() async {
    cats = (await Api().getCats());
  }

  bool isLoading = true;

  @override
  initState() {
    getCats();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (cats.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
      }

      if (!isLoading) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? (const Center(child: CircularProgressIndicator()))
            : (SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var cat in cats) CustomCard(url: cat["url"])
                    ],
                  ),
                ),
              )),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String url;
  const CustomCard({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Image.network(
        url,
        width: size.width * 0.95,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}
*/
