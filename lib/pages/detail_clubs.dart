// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:plan_it_on/Models/clubs.dart';
// import 'package:url_launcher/url_launcher.dart';

// class DetailScreen extends StatelessWidget {
//   final Club club;
//   const DetailScreen(this.club);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       bottomNavigationBar: Container(
//         color: Theme.of(context).primaryColor,
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Builder(
//                 builder: (context) => FlatButton.icon(
//                   onPressed: () {
                   
//                   },
//                   icon: Icon(Icons.launch),
//                   label: Text("Visit Listing"),
//                   textColor: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             pinned: true,
//             floating: false,
//             expandedHeight: 256,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: <Widget>[
//                   Image.network(
//                     club.poster,
//                     fit: BoxFit.cover,
//                   ),
//                   // This gradient ensures that the toolbar icons are distinct
//                   // against the background image.
//                   const DecoratedBox(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment(0.0, -1.0),
//                         end: Alignment(0.0, -0.4),
//                         colors: <Color>[Color(0x60000000), Color(0x00000000)],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 16),
//                       color: Color.fromRGBO(255, 255, 255, 0.5),
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: Icon(
//                               FontAwesomeIcons.tag,
//                               size: 20,
//                               color: Theme.of(context).accentColor,
//                             ),
//                           ),
//                           Text(
//                             club.avgPrice.toString(),
//                             style: Theme.of(context).textTheme.headline6,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//               delegate: SliverChildListDelegate([
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16),
//               margin: const EdgeInsets.only(bottom: 4),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     club.name,
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline6
//                         .copyWith(fontSize: 24.0),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(vertical: 16.0),
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         top: BorderSide(color: Colors.grey, width: 0.4),
//                         bottom: BorderSide(color: Colors.grey, width: 0.4),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         TextIcon(
//                           icon: FontAwesomeIcons.clock,
//                           text: "${club.timings ?? "#"} Bedrooom",
//                         ),
//                         // TextIcon(
//                         //   icon: FontAwesomeIcons.shower,
//                         //   text: "${club.bathroomNumber ?? "#"} Bathrooom",
//                         // ),
//                         // TextIcon(
//                         //   icon: FontAwesomeIcons.car,
//                         //   text: "${club.carSpaces ?? "#"} Carspace",
//                         // )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               margin: const EdgeInsets.symmetric(vertical: 4.0),
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     "Summary",
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline6
//                         .copyWith(fontSize: 20),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text(club.description),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 4.0),
//                     child: Text(
//                       "Tags",
//                       style: Theme.of(context).textTheme.subtitle2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               margin: const EdgeInsets.symmetric(vertical: 4.0),
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text(
//                       "Lister",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline6
//                           .copyWith(fontSize: 20.0),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ]))
//         ],
//       ),
//     );
//   }
// }

// class TextIcon extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final bool isColumn;
//   final double size;

//   const TextIcon(
//       {Key key,
//         @required this.icon,
//         @required this.text,
//         this.isColumn = true,
//         this.size = 12})
//       : assert(size <= 24.0),
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (isColumn) {
//       return Container(
//         height: 50.0,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Icon(icon),
//             Text(text),
//           ],
//         ),
//       );
//     } else {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Row(
//           children: <Widget>[
//             Text(
//               text,
//               style: TextStyle(fontSize: size),
//             ),
//             SizedBox(
//               width: 4.0,
//             ),
//             Icon(
//               icon,
//               size: size,
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }