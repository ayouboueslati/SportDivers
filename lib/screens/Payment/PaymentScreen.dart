import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/PaymentProvider/PaymentProvider.dart';
import 'package:sportdivers/models/payment.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PaymentScreen extends StatelessWidget {
  static String id = 'Payment_Screen';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (context) => PaymentProvider()..fetchPayments(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              splashColor: DailozColor.transparent,
              highlightColor: DailozColor.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: height / 20,
                width: height / 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: DailozColor.white,
                    boxShadow: const [
                      BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(left: width / 56),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: DailozColor.black,
                  ),
                ),
              ),
            ),
          ),
          title: Text("Historique des paiements",
              style: hsSemiBold.copyWith(fontSize: 22)),
        ),
        body: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            if (paymentProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container(
              color: Colors.grey[100],
              child: ListView.builder(
                itemCount: paymentProvider.payments.length,
                itemBuilder: (context, index) {
                  return TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: index == 0,
                    isLast: index == paymentProvider.payments.length - 1,
                    indicatorStyle: IndicatorStyle(
                      width: 25,
                      color: paymentProvider.payments[index].paid
                          ? Colors.green[500]!
                          : Colors.red[500]!,
                      padding: const EdgeInsets.all(6),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: paymentProvider.payments[index].paid
                            ? Icons.check
                            : Icons.close,
                      ),
                    ),
                    endChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 8, bottom: 4),
                          child: Text(
                            paymentProvider.payments[index].formattedDate,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        PaymentItem(
                          payment: paymentProvider.payments[index],
                          onPay: () => paymentProvider
                              .makePayment(paymentProvider.payments[index].id),
                        ),
                      ],
                    ),
                    beforeLineStyle: LineStyle(
                      color: Colors.blue[500]!,
                      thickness: 2,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class PaymentItem extends StatelessWidget {
  final Payment payment;
  final VoidCallback onPay;

  PaymentItem({
    required this.payment,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          // Handle tap if needed
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.blue[50], // Light blue background
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Montant: ${payment.amount.toStringAsFixed(3)} DT',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      'Heure: ${payment.formattedTime}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (payment.type != null)
                  Text(
                    'Type: ${payment.type}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                if (payment.depositDate != null)
                  Text(
                    'Date de dépôt: ${payment.formattedDepositDate}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 12),
                if (payment.paid)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Payé le ${payment.formattedPaidAt}',
                      style: TextStyle(
                          color: Colors.green[500],
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'À payer',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
