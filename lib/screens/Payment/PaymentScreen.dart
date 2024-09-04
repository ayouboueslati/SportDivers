import 'package:flutter/material.dart';
import 'package:footballproject/Provider/PaymentProvider/PaymentProvider.dart';
import 'package:footballproject/models/payment.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PaymentScreen extends StatelessWidget {
  static String id = 'Payment_Screen';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentProvider()..fetchPayments(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          shadowColor: Colors.grey.withOpacity(0.3),
          elevation: 5,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.blue[900],
          title: const Text(
            'Historique des paiements',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        body: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            if (paymentProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
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
                      color: paymentProvider.payments[index].paid ? Colors.green[600]! : Colors.red[600]!,
                      padding: EdgeInsets.all(6),
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: paymentProvider.payments[index].paid ? Icons.check : Icons.close,
                      ),
                    ),
                    endChild: PaymentItem(
                      payment: paymentProvider.payments[index],
                      onPay: () => paymentProvider.makePayment(paymentProvider.payments[index].id),
                    ),
                    beforeLineStyle: LineStyle(
                      color: Colors.blue[900]!,
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
    return Card(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paiement #${payment.id.substring(0, 8)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  payment.formattedDate,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Montant: ${payment.amount.toStringAsFixed(3)} DT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Heure: ${payment.formattedTime}',
              style: TextStyle(color: Colors.grey[600]),
            ),
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
            SizedBox(height: 12),
            if (payment.paid)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Payé le ${payment.formattedPaidAt}',
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                ),
              )
            else
              // ElevatedButton(
              //   onPressed: onPay,
              //   child: Text('À payer'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue[900],
              //     foregroundColor: Colors.white,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   ),
              // ),
              Container(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Center(
                  child: Text(
                    'À payer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}