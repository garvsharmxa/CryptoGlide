import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isNotificationsEnabled = true;
  bool isPriceAlertEnabled = true;
  bool isTwoFactorAuthEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        shadowColor: Colors.grey,
      ),

      body: ListView(
        children: [
          _buildSettingsTile("Notifications", isNotificationsEnabled, (value) {
            setState(() {
              isNotificationsEnabled = value;
            });
          }, Icons.notifications),
          _buildSettingsTile("Price Alerts", isPriceAlertEnabled, (value) {
            setState(() {
              isPriceAlertEnabled = value;
            });
          }, Icons.attach_money),
          const Divider(),
          _buildOptionTile("Security", Icons.lock, () {}),
          _buildOptionTile(
            "Two-Factor Authentication",
            Icons.shield,
            () {},
            isTwoFactorAuthEnabled,
            (value) {
              setState(() {
                isTwoFactorAuthEnabled = value;
              });
            },
          ),

          _buildOptionTile(
            "Manage Wallets",
            Icons.account_balance_wallet,
            () {},
          ),
          _buildOptionTile("Transaction History", Icons.history, () {}),
          _buildOptionTile("Backup & Restore", Icons.cloud_upload, () {}),
          const Divider(),
          _buildOptionTile("Terms & Conditions", Icons.description, () {}),
          _buildOptionTile("Help & Support", Icons.help, () {}),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.greenAccent,
      ),
    );
  }

  Widget _buildOptionTile(
    String title,
    IconData icon,
    VoidCallback onTap, [
    bool? switchValue,
    Function(bool)? onSwitchChanged,
  ]) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing:
          switchValue != null
              ? Switch(
                value: switchValue,
                onChanged: (bool value) {
                  if (onSwitchChanged != null) {
                    onSwitchChanged(value);
                  }
                },
                activeColor: Colors.greenAccent,
              )
              : Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
