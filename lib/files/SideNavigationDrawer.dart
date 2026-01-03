import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ProfileDrawerScreen extends StatelessWidget {
  const ProfileDrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Stack(
        children: [
          /// 🔵 BLUE HEADER
          Container(
            height: 220,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF114BBE),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,
                          size: 30, color: Color(0xFF114BBE)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Narasimha Rao",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "+91 98765 43210",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Member since Nov 2024",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          /// 🧾 CONTENT
          Positioned.fill(
            top: 170,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              children: [
                /// 🔹 STATS CARD
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Column(
                          children: [
                            Text("47",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Total Rides",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text("4.9",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Your Rating",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 💜 MONTHLY PASS CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A5CFF), Color(0xFFB000FF)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.workspace_premium,
                          color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Get a Monthly Pass",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Save up to 25% on every ride",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _section("ACCOUNT"),
                _card([
                  _tile(Icons.person_outline, "Edit Profile"),
                  _tile(Icons.warning_amber_outlined, "Emergency Contacts"),
                  _tile(Icons.location_on_outlined, "Saved Places"),
                  _tile(Icons.credit_card, "Payment Methods"),
                  _tile(Icons.account_balance_wallet_outlined, "Wallet"),
                ]),

                const SizedBox(height: 16),

                _section("PREFERENCES"),
                _card([
                  _tile(Icons.notifications_none, "Notifications"),
                  _tile(Icons.security_outlined, "Privacy & Safety"),
                ]),

                const SizedBox(height: 16),

                _section("SUPPORT"),
                _card([
                  _tile(Icons.help_outline, "Help & Support"),
                  _tile(Icons.description_outlined, "Terms & Conditions"),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION TITLE
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// GROUP CARD
  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  /// LIST TILE
  Widget _tile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }
}

//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         /// 🔵 TOP BLUE HEADER
//           Container(
//             padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Color(0xFF114BBE),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(24),
//                 bottomRight: Radius.circular(24),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Profile Row
//                 Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 28,
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.person,
//                           size: 32, color: Color(0xFF114BBE)),
//                     ),
//                     const SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Narasimha Rao",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "+91 98765 43210",
//                           style: TextStyle(
//                               color: Colors.white70, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 /// Member since
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Text(
//                     "Member since Nov 2024",
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// CONTENT
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 /// STATS CARD
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Row(
//                     children: const [
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Text("47",
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold)),
//                             SizedBox(height: 4),
//                             Text("Total Rides",
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.grey)),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Text("4.9",
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold)),
//                             SizedBox(height: 4),
//                             Text("Your Rating",
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.grey)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 /// MONTHLY PASS
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF6A5CFF), Color(0xFFB000FF)],
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Row(
//                     children: const [
//                       Icon(Icons.workspace_premium,
//                           color: Colors.white, size: 28),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Get a Monthly Pass",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               "Save up to 25% on every ride",
//                               style: TextStyle(
//                                   color: Colors.white70, fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(Icons.arrow_forward_ios,
//                           color: Colors.white, size: 16),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 _section("ACCOUNT"),
//                 _tile(Icons.person_outline, "Edit Profile"),
//                 _tile(Icons.warning_amber_outlined, "Emergency Contacts"),
//                 _tile(Icons.location_on_outlined, "Saved Places"),
//                 _tile(Icons.credit_card, "Payment Methods"),
//                 _tile(Icons.account_balance_wallet_outlined, "Wallet"),
//
//                 const SizedBox(height: 16),
//
//                 _section("PREFERENCES"),
//                 _tile(Icons.notifications_none, "Notifications"),
//                 _tile(Icons.security_outlined, "Privacy & Safety"),
//
//                 const SizedBox(height: 16),
//
//                 _section("SUPPORT"),
//                 _tile(Icons.help_outline, "Help & Support"),
//                 _tile(Icons.description_outlined, "Terms & Conditions"),
//               ],
//             ),
//           ),
//         ],
//       );
//   }
//
//   /// Helpers
//   Widget _section(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text(title,
//           style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//               fontWeight: FontWeight.w600)),
//     );
//   }
//
//   Widget _tile(IconData icon, String text) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.black87),
//         title: Text(text),
//         trailing:
//         const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
//         onTap: () {},
//       ),
//     );
//   }
// }
