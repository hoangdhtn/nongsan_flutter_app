import 'package:bannongsan/models/customer_detail_model.dart';
import 'package:bannongsan/pages/payment_methods.dart';
import 'package:bannongsan/provider/cart_provider.dart';
import 'package:bannongsan/utils/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_base.dart';

class VerifyAddress extends CheckoutBasePage {
  // const VerifyAddress({ Key? key }) : super(key: key);

  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutBasePageState<VerifyAddress> {
  @override
  void initState() {
    super.initState();
    currentPage = 0;
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, customerModel, child) {
        if (customerModel.customerDetailsModel.id != null) {
          return _formUI(customerModel.customerDetailsModel);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _formUI(CustomerDetailsModel model) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Họ"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Tên"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child:
                          FormHelper.fieldLabelValue(context, model.firstName),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child:
                            FormHelper.fieldLabelValue(context, model.lastName),
                      ),
                    ),
                  ],
                ),
                FormHelper.fieldLabel("Địa chỉ"),
                FormHelper.fieldLabelValue(context, model.shipping.address1),
                FormHelper.fieldLabel("Căn hộ, chung cư"),
                FormHelper.fieldLabelValue(context, model.shipping.address2),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Quê quán"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Tỉnh"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabelValue(
                          context, model.shipping.country),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.state),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Thành phố"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Postcode"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabelValue(
                          context, model.shipping.city),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.postcode),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                new Center(
                  child: FormHelper.saveButton("Tiếp theo", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethodsWidget()));
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
