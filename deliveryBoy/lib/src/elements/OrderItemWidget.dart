import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../helpers/helper.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/route_argument.dart';

class OrderItemWidget extends StatelessWidget {
  final String heroTag;
  final String idorder;
  final String description;
  final int cant;
  final double price;

  const OrderItemWidget(
      {Key key,
      this.heroTag,
      this.description,
      this.cant,
      this.price,
      this.idorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Tracking',
            arguments: RouteArgument(id: idorder, heroTag: this.heroTag));
        //print('hola mundo');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Hero(
            //   tag: heroTag + idorder,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.all(Radius.circular(5)),
            //     child: CachedNetworkImage(
            //       height: 60,
            //       width: 60,
            //       fit: BoxFit.cover,
            //       //imageUrl: foodOrder.food.image.thumb,
            //       placeholder: (context, url) => Image.asset(
            //         'assets/img/loading.gif',
            //         fit: BoxFit.cover,
            //         height: 60,
            //         width: 60,
            //       ),
            //       errorWidget: (context, url, error) => Icon(Icons.error),
            //     ),
            //   ),
            // ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          'Cantidad: $cant',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // Helper.getPrice(
                      //     Helper.getTotalOrderPrice(foodOrder, order.tax),
                      //     style: Theme.of(context).textTheme.display1),
                      Text(
                        '',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        //DateFormat('HH:mm').format(foodOrder.dateTime),
                        '$price',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
