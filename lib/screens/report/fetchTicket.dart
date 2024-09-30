import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/ReportPorivder/ticketProvider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

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
    final DateFormat formatter = DateFormat('dd MMMM'); // Formats to "24 août"
    return formatter.format(dateTime);
  }

  String formatTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('HH:mm').format(dateTime); // Formats to "14:30"
  }

  void _showTicketDetails(BuildContext context, Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Allows the modal to take up more space
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                            'Date', formatDate(ticket['createdAt'])),
                        _buildDetailRow(
                            'Heure', formatTime(ticket['createdAt'])),
                        _buildDetailRow(
                            'Raison', ticket['reason'] ?? 'Aucune raison'),
                        _buildDetailRow('Commentaire',
                            ticket['comment'] ?? 'Aucun commentaire'),
                        _buildDetailRow('Créé par',
                            '${ticket['createdBy']['profile']['firstName']} ${ticket['createdBy']['profile']['lastName']}'),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blue[900],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticketsProvider = Provider.of<TicketsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Mes tickets',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: ticketsProvider.isLoading
          ? _buildShimmerLoading()
          : ticketsProvider.errorMessage.isNotEmpty
              ? Center(child: Text(ticketsProvider.errorMessage))
              : ticketsProvider.tickets.isEmpty
                  ? const Center(child: Text('Aucun billet trouvé'))
                  : ListView.builder(
                      itemCount: ticketsProvider.tickets.length,
                      itemBuilder: (context, index) {
                        final reversedTickets =
                            ticketsProvider.tickets.reversed.toList();
                        final ticket = reversedTickets[index];
                        final date = formatDate(ticket['createdAt']);
                        final time = formatTime(ticket['createdAt']);
                        return GestureDetector(
                          onTap: () => _showTicketDetails(context, ticket),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: index == 0
                                              ? Colors.blue[900]
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              date,
                                              style: TextStyle(
                                                color: index == 0
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              time,
                                              style: TextStyle(
                                                color: index == 0
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ticket['reason'] ??
                                                  'Aucune raison',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Commentaire : ${ticket['comment'] ?? 'Aucun commentaire'}',
                                              style: TextStyle(fontSize: 14),
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Créé par : ${ticket['createdBy']['profile']['firstName']} ${ticket['createdBy']['profile']['lastName']}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.calendar_today_outlined),
                                        onPressed: () {
                                          // Ajoutez votre fonctionnalité ici pour ajouter au calendrier
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
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            title: Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[200]!,
              child: Container(
                width: double.infinity,
                height: 20.0,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[200]!,
                  child: Container(
                    width: double.infinity,
                    height: 14.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[200]!,
                  child: Container(
                    width: 150.0,
                    height: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
