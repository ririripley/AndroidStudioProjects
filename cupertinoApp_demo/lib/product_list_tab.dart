import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'model/app_state_model.dart';
import 'product_row_item.dart';      // NEW

class ProductListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        final products = model.getProducts(); /// model即AppStateModel
        return CustomScrollView(   /// 回去研究一下Consumer的闭包，怎么build的，容易混乱
          semanticChildCount: products.length,
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Cupertino Store'),
            ),
            SliverSafeArea(  // BEGINNING OF NEW CONTENT
              top: false,
              minimum: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index < products.length) {
                      return ProductRowItem(
                        index: index,
                        product: products[index],
                        lastItem: index == products.length - 1,
                      );
                    }

                    return null;
                  },
                ),
              ),
            )                // END OF NEW CONTENT
          ],
        );
      },
    );
  }
}