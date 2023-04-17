import 'package:bezetting_indeler/widgets/occupation/occupation_place.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OccupationOverview extends StatelessWidget {
  final String club;
  final DateTime targetDate;
  final String logoUrl;
  final List<dynamic> places;

  OccupationOverview(this.club, this.targetDate, this.logoUrl, this.places);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 3),
      child: Card(
        elevation: 5,
        child: Container(
          constraints: BoxConstraints(minHeight: 120),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy').format(targetDate),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      club,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: places
                          .map((place) => OccupationPlace(place))
                          .toList(),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  maxRadius: 30,
                  backgroundImage: NetworkImage(logoUrl),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
