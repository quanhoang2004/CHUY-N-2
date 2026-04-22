import 'package:flutter/material.dart';
import '../app_state.dart';
import 'tracking_page.dart';

class CheckoutPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onStateChanged;

  const CheckoutPage({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPayment = 'Tiền mặt';
  bool isLoading = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> _placeOrder() async {
    if (widget.appState.cart.isEmpty) return;

    setState(() => isLoading = true);

    await widget.appState.checkout(
      paymentMethod: selectedPayment,
      customerName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      note: noteController.text.trim(),
    );

    widget.onStateChanged();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingPage(
          appState: widget.appState,
          onStateChanged: widget.onStateChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Text('Thông tin nhận hàng', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: _decoration('Họ tên'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: _decoration('Số điện thoại'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: _decoration('Địa chỉ'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: _decoration('Ghi chú'),
            ),
            const SizedBox(height: 20),
            const Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _paymentTile('Tiền mặt'),
            _paymentTile('Thẻ'),
            _paymentTile('Momo'),
            const SizedBox(height: 20),
            const Text('Tóm tắt đơn hàng', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _row('Tạm tính', appState.cartTotal),
            _row('Phí giao hàng', appState.deliveryFee),
            _row('Thuế', appState.taxFee),
            const Divider(),
            _row('Tổng cộng', appState.grandTotal, isBold: true),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: isLoading ? null : _placeOrder,
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Đặt hàng'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _paymentTile(String title) {
    final selected = selectedPayment == title;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPayment = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFCDEAAF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, double amount, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          '${amount.toStringAsFixed(0)} đ',
          style: TextStyle(fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
        ),
      ],
    );
  }
}