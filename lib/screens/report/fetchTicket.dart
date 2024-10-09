import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/ReportPorivder/ticketProvider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class TicketsScreen extends StatefulWidget {
  static String id = 'fetch_ticket';

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketsProvider>(context, listen: false).fetchTickets();
    });
  }

  String formatDate(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMMM');
    return formatter.format(dateTime);
  }

  String formatTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('HH:mm').format(dateTime);
  }

  void _showTicketDetails(BuildContext context, Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Détails du ticket',
                  style: hsSemiBold.copyWith(fontSize: 22, color: DailozColor.appcolor),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Date', formatDate(ticket['createdAt'])),
                        _buildDetailRow('Heure', formatTime(ticket['createdAt'])),
                        _buildDetailRow('Raison', ticket['reason'] ?? 'Aucune raison'),
                        _buildDetailRow('Commentaire', ticket['comment'] ?? 'Aucun commentaire'),
                        _buildDetailRow('Créé par', '${ticket['createdBy']['profile']['firstName']} ${ticket['createdBy']['profile']['lastName']}'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: hsSemiBold.copyWith(fontSize: 14, color: DailozColor.textgray),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticketsProvider = Provider.of<TicketsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
              height: height/20,
              width: height/20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: DailozColor.white,
                  boxShadow: const [
                    BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                  ]
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width/56),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: DailozColor.black,
                ),
              ),
            ),
          ),
        ),
        title: Text("Mes tickets", style: hsSemiBold.copyWith(fontSize: 22)),
      ),
      body: ticketsProvider.isLoading
          ? _buildShimmerLoading()
          : ticketsProvider.errorMessage.isNotEmpty
          ? Center(child: Text(ticketsProvider.errorMessage, style: hsMedium.copyWith(color: DailozColor.textgray)))
          : ticketsProvider.tickets.isEmpty
          ? Center(child: Text('Aucun Ticket trouvé', style: hsMedium.copyWith(color: DailozColor.textgray)))
          : ListView.builder(
        itemCount: ticketsProvider.tickets.length,
        itemBuilder: (context, index) {
          final reversedTickets = ticketsProvider.tickets.reversed.toList();
          final ticket = reversedTickets[index];
          final date = formatDate(ticket['createdAt']);
          final time = formatTime(ticket['createdAt']);
          return GestureDetector(
            onTap: () => _showTicketDetails(context, ticket),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: DailozColor.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: index == 0 ? DailozColor.appcolor : DailozColor.bggray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                date,
                                style: hsMedium.copyWith(
                                  fontSize: 14,
                                  color: index == 0 ? DailozColor.white : DailozColor.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                time,
                                style: hsSemiBold.copyWith(
                                  fontSize: 18,
                                  color: index == 0 ? DailozColor.white : DailozColor.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticket['reason'] ?? 'Aucune raison',
                                style: hsSemiBold.copyWith(fontSize: 16, color: DailozColor.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Commentaire : ${ticket['comment'] ?? 'Aucun commentaire'}',
                                style: hsMedium.copyWith(fontSize: 14, color: DailozColor.textgray),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Créé par : ${ticket['createdBy']['profile']['firstName']} ${ticket['createdBy']['profile']['lastName']}',
                                style: hsMedium.copyWith(fontSize: 14, color: DailozColor.textgray),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today_outlined, color: DailozColor.textgray),
                          onPressed: () {
                            // Add functionality for adding to calendar
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: DailozColor.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: DailozColor.textgray, blurRadius: 5)
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 14.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150.0,
                    height: 14.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}