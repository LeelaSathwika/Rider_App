import 'package:flutter/material.dart';
import '../../constants.dart';
import 'subscription_plans_screen.dart';
import 'wallet_screen.dart';
import 'emergency_contacts_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Light greyish-blue background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. THE TOP BLUE HEADER
            _buildBlueHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. OVERLAPPING STATS CARD (Total Rides & Rating)
                  _buildOverlapStatsCard(),

                  const SizedBox(height: 10),

                  // 3. MONTHLY PASS GRADIENT CARD
                  _buildMonthlyPassCard(context),

                  const SizedBox(height: 30),

                  // 4. ACCOUNT SECTION
                  _buildSectionLabel("ACCOUNT"),
                  _buildSettingsGroup([
                    _settingsTile(Icons.person_outline, "Edit Profile"),
                    // Inside profile_screen.dart -> _settingsTile for Emergency Contacts
                    _settingsTile(
                      Icons.contact_emergency_outlined, 
                      "Emergency Contacts", 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
                        );
                      },
                    ),
                    _settingsTile(Icons.place_outlined, "Saved Places"),
                    _settingsTile(Icons.payment_outlined, "Payment Methods"),
                    // FIXED: Now correctly navigates to Wallet
                    _settingsTile(
                      Icons.account_balance_wallet_outlined, 
                      "Wallet", 
                      onTap: () { 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WalletScreen()),
                        );
                      }
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 5. PREFERENCES SECTION
                  _buildSectionLabel("PREFERENCES"),
                  _buildSettingsGroup([
                    _settingsTile(Icons.notifications_none_outlined, "Notifications"),
                    _settingsTile(Icons.shield_outlined, "Privacy & Safety"),
                  ]),

                  const SizedBox(height: 25),

                  // 6. SUPPORT SECTION
                  _buildSectionLabel("SUPPORT"),
                  _buildSettingsGroup([
                    _settingsTile(Icons.help_outline, "Help & Support"),
                    _settingsTile(Icons.description_outlined, "Terms & Conditions"),
                  ]),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENT BUILDERS ---

  Widget _buildBlueHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 60),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, size: 45, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Narasihma Rao",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+91 98765 43210",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Member since Nov 2024",
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlapStatsCard() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text("47", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("Total Rides", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              const VerticalDivider(color: Colors.black12, thickness: 1),
              Expanded(
                child: Column(
                  children: [
                    const Text("4.9", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("Your Rating", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyPassCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubscriptionPlansScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.workspace_premium, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get a Monthly Pass",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Save up to 25% on every ride",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(children: children),
    );
  }

  // UPDATED: Added VoidCallback parameter to handle clicks
  Widget _settingsTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
      onTap: onTap, // Now uses the callback provided
    );
  }
}