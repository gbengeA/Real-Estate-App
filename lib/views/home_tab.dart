import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin<HomeScreen> {
  late AnimationController _animationController;
  SequenceAnimation? sequenceAnimation;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int buyPrice = 1034;
  int rentPrice = 2212;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
      //     begin: screenHeight * 0.8,
      // end: screenHeight * 0.43,
          setState(() {
           // sequenceAnimation!["search"] = 500;
          });
        } else {
          setState(() {

          });
          // Bottom of the list
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        screenHeight = MediaQuery.of(context).size.height;

        screenWidth = MediaQuery.of(context).size.width;
        sequenceAnimation = SequenceAnimationBuilder()
            .addAnimatable(
              animatable: Tween<double>(begin: 0, end: 1.0),
              from: const Duration(seconds: 0),
              to: const Duration(seconds: 2),
              tag: "scale_profile",
            )
            .addAnimatable(
              animatable: Tween<double>(begin: 0, end: 1),
              from: const Duration(seconds: 1),
              to: const Duration(seconds: 3),
              curve: Curves.linear,
              tag: "search",
            )
            .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1),
          from: const Duration(seconds: 1),
          to: const Duration(seconds: 2),
          curve: Curves.linear,
          tag: "search_opacity",
        )
            .addAnimatable(
              animatable: Tween<double>(
                  begin: 0, // Starts above the screen
                  end: screenHeight * 0.15  ),
              from: const Duration(seconds: 2),
              to: const Duration(seconds: 4),
              curve: Curves.easeOut,
              tag: "welcome_note",
            )
            .addAnimatable(
          animatable: IntTween(begin: 0, end: buyPrice),
          from: const Duration(seconds: 0),
          to: const Duration(seconds: 4),
          tag: "buyPrice",
        )
            .addAnimatable(
          animatable: IntTween(begin: 0, end: rentPrice),
          from: const Duration(seconds: 0),
          to: const Duration(seconds: 4),
          tag: "rentPrice",
        )
            .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1.0),
          from: const Duration(seconds: 1),
          to: const Duration(seconds: 3),
          tag: "scale_price",
        )
            .addAnimatable(
              animatable: TweenSequence<double>([
                TweenSequenceItem(
                  tween: Tween<double>(begin: 0.0, end: screenHeight * 0.8),
                  weight: 2, // First half of the animation
                ),
                TweenSequenceItem(
                  tween: Tween<double>(
                    begin: screenHeight * 0.8,
                    end: screenHeight * 0.43,
                  ),
                  weight: 1, // Second half of the animation
                ),
              ]),
              from: const Duration(seconds: 4),
              to: const Duration(seconds: 7),
              tag: "more_item_height",
            )
            .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1),
          from: const Duration(seconds: 5),
          to: const Duration(seconds: 7),
          tag: "scale_btn",
        )
            .animate(_animationController);
        _animationController.forward();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final textStyleWelcome = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {

    return sequenceAnimation == null
        ? Container()
        : AnimatedBuilder(
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFFAD5AA)],
                ),
              ),

              child: Scaffold(

                appBar: AppBar(
                 forceMaterialTransparency:  true, 
                  elevation: 0,
                  title: Transform.scale(
                    alignment: Alignment.centerLeft,
                    scaleX:   sequenceAnimation!["search"].value  ,
                    child: Container(

                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),

                           //width: sequenceAnimation!["search"].value,
                          decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:

                          Opacity(
                            opacity:sequenceAnimation!["search_opacity"].value ,
                            child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color.fromRGBO(93, 91, 88, 1),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Saint Petersburg',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(93, 91, 88, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),

                  ),
                  actions: [
                    Transform.scale(
                      scale:  sequenceAnimation?["scale_profile"].value ??
                          Offset(-1, 0),
                      child: Container(
                        // Profile image
                        margin: EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                body: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFFFFF), Color(0xFFFAD5AA)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Opacity(
                        opacity:sequenceAnimation!["search_opacity"].value ,
                        child:  Text(
                          'Hi, Marina',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(93, 91, 88, 1),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

              SizedBox(
              height: sequenceAnimation!["welcome_note"].value  ,
                        child: Text(
                          "Let's select your perfect place",
                          style: textStyleWelcome,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Transform.scale(
                            scale: sequenceAnimation?["scale_price"].value ?? 0,
                            child: _buildOfferCardCircle(
                              sequenceAnimation?["buyPrice"].value ?? 0,
                            ),
                          ),
                          Transform.scale(
                            scale: sequenceAnimation?["scale_price"].value ?? 0,
                            child: _buildOfferCardSquare(
                              sequenceAnimation?["rentPrice"].value ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                bottomSheet: SizedBox(
                  height: sequenceAnimation?["more_item_height"].value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        // Allows it to take available space
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController ,
                            child: Column(
                              children: [
                                _buildPropertyCard(
                                  'Gladkova St, 25',
                                  'assets/images/store.png',
                                  true,
                                  true,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildPropertyCard(
                                      'Trakova St, 43',
                                      'assets/images/store.png',
                                      false,
                                      false,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildPropertyCard(
                                          'Kazanskaya St, 12',
                                          'assets/images/store.png',
                                          false,
                                          true,
                                        ),
                                        _buildPropertyCard(
                                          'Kazanskaya St, 12',
                                          'assets/images/store.png',
                                          false,
                                          true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 100,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          animation: _animationController,
        );
  }

  Widget _buildOfferCardCircle(int offer) {
    return Container(
      constraints: BoxConstraints(minWidth: 150, maxHeight: 150),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(252, 158, 18, 1),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Buy",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Text(
            offer.toString(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text("offer", style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildOfferCardSquare(int offer) {
    return Container(
      constraints: BoxConstraints(minWidth: 150, maxHeight: 150),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFfefbf8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Rent",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(93, 91, 88, 1),
              ),
            ),
          ),
          Text(
            offer.toString(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(93, 91, 88, 1),
            ),
          ),
          Text(
            "offer",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(93, 91, 88, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(
    String address,
    String imagePath,
    bool fullWidth,
    bool specifyHeight,
  ) {
   double availableWidth= ((fullWidth?0.9:0.43)*screenWidth);
   double scalePosition =  availableWidth-
       (sequenceAnimation?["scale_btn"].value as double) *availableWidth;

    if(scalePosition<16){
      scalePosition=16;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: specifyHeight ? screenHeight * 0.2 : screenWidth * 0.9,
              width: fullWidth ? double.infinity : screenWidth * 0.43,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 8,
            left: 16,
            right: scalePosition,
          child:
          Container(
             height: 35,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(30),
                 gradient: LinearGradient(
                   begin: Alignment.topLeft,
                   end: Alignment.bottomRight,
                   colors: [Color(0xFFFFFFFF), Color(0xFFF0E6DC)],
                 ),
               ),

               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Expanded(
                     flex: 1,
                     child: Text(
                       address,
                       maxLines: 1,
                       style: TextStyle(
                         fontSize: 12,
                         fontWeight: FontWeight.bold,
                       ),
                       textAlign: TextAlign.center,
                     ),
                   ),
                  Flexible(
                    flex: 0,
                       child: InkWell(
                         onTap: () {},
                         child: Container(
                           decoration: BoxDecoration(
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey,
                                 spreadRadius: 3,
                                 blurRadius: 15,
                                 offset: Offset(-2, 0),
                               ),
                             ],
                             shape: BoxShape.circle,
                             color: Color.fromRGBO(253, 246, 239, 1),
                           ),
                           child:   Icon(Icons.arrow_forward_ios, size: 30,),

                         ),
                       )),
                 ],
               )),
         )
          //  ),

        ],
      ),
    );
  }

}
