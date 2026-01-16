import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  // Initial list of contacts matching your image
  List<Map<String, String>> contacts = [
    {"name": "Mom", "phone": "+91 98765 43210"},
    {"name": "Priya", "phone": "+91 98765 43210"},
    {"name": "Rahul", "phone": "+91 98765 43210"},
    {"name": "Dad", "phone": "+91 98765 43210"},
  ];

  // Function to show the "Add Contact" Modal Bottom Sheet
  void _showAddContactSheet() {
    String newName = "";
    String newPhone = "";
    String newRelation = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add Contact", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  
                  _formLabel("Full Name"),
                  _formField(Icons.person_outline, "Enter your name", (val) => newName = val),
                  
                  const SizedBox(height: 20),
                  _formLabel("Mobile Number"),
                  _formField(Icons.phone_outlined, "Enter 10 digit mobile number", (val) => newPhone = val, isPhone: true),
                  
                  const SizedBox(height: 20),
                  _formLabel("Relation"),
                  _formField(Icons.people_outline, "Select relation", (val) => newRelation = val, isDropdown: true),
                  
                  const SizedBox(height: 40),
                  buildPrimaryButton(
                    text: "Save Contact",
                    onPressed: () {
                      if (newName.isNotEmpty && newPhone.isNotEmpty) {
                        setState(() {
                          contacts.add({"name": newName, "phone": "+91 $newPhone"});
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Emergency Contacts", // Changed from "Wallet" to "Emergency Contacts"
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black12, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return _buildContactCard(contacts[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: buildPrimaryButton(
              text: "Add Contact",
              onPressed: _showAddContactSheet,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, String> contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(contact['phone']!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: Colors.blueGrey, size: 22),
          const SizedBox(width: 20),
          const Icon(Icons.delete_outline, color: Colors.red, size: 22),
        ],
      ),
    );
  }

  Widget _formLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 15)),
    );
  }

  Widget _formField(IconData icon, String hint, Function(String) onChanged, {bool isPhone = false, bool isDropdown = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        onChanged: onChanged,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: isPhone 
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.phone_outlined, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text("+91", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                ],
              )
            : Icon(icon, color: Colors.grey, size: 20),
          hintText: hint,
          suffixIcon: isDropdown ? const Icon(Icons.keyboard_arrow_down) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}