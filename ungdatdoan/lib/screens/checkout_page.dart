import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../services/order_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  final couponController = TextEditingController();

  final orderService = OrderService();

  bool isLoading = false;
  String paymentMethod = 'Tiền mặt';

  final List<String> paymentMethods = [
    'Tiền mặt',
    'Ví điện tử',
    'Thẻ ngân hàng',
  ];

  @override
  void dispose() {
    addressController.dispose();
    phoneController.dispose();
    noteController.dispose();
    couponController.dispose();
    super.dispose();
  }

  String formatPrice(int price) {
    final text = price.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }

    return buffer.toString().split('').reversed.join();
  }

  Future<void> placeOrder(CartProvider cart) async {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng đang trống')),
      );
      return;
    }

    if (addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ và số điện thoại')),
      );
      return;
    }

    setState(() => isLoading = true);

    await orderService.createOrder(
      totalAmount: cart.finalTotal,
      deliveryFee: cart.deliveryFee,
      discountAmount: cart.discountAmount,
      couponCode: cart.couponCode,
      paymentMethod: paymentMethod,
      paymentStatus:
      paymentMethod == 'Tiền mặt' ? 'Chưa thanh toán' : 'Đã thanh toán',
      address: addressController.text.trim(),
      phone: phoneController.text.trim(),
      note: noteController.text.trim(),
    );

    cart.clear();

    if (!mounted) return;

    setState(() => isLoading = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Đặt hàng thành công'),
          content: Text(
            paymentMethod == 'Tiền mặt'
                ? 'Bạn sẽ thanh toán bằng tiền mặt khi nhận hàng.'
                : 'Thanh toán $paymentMethod đã được ghi nhận mô phỏng.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Giỏ hàng đang trống'))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  section(
                    title: 'Thông tin giao hàng',
                    child: Column(
                      children: [
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Địa chỉ giao hàng',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                        ),
                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Số điện thoại',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        TextField(
                          controller: noteController,
                          decoration: const InputDecoration(
                            labelText: 'Ghi chú cho tài xế',
                            prefixIcon: Icon(Icons.note_alt_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  section(
                    title: 'Phương thức thanh toán',
                    child: Column(
                      children: paymentMethods.map((method) {
                        return RadioListTile<String>(
                          value: method,
                          groupValue: paymentMethod,
                          activeColor: const Color(0xFFEE4D2D),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => paymentMethod = value);
                          },
                          title: Text(method),
                          secondary: Icon(
                            method == 'Tiền mặt'
                                ? Icons.payments_outlined
                                : method == 'Ví điện tử'
                                ? Icons.account_balance_wallet_outlined
                                : Icons.credit_card,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  section(
                    title: 'Mã giảm giá',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: couponController,
                            decoration: const InputDecoration(
                              hintText: 'GIAM20 hoặc FREESHIP',
                              prefixIcon: Icon(Icons.local_offer_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            final ok = cart.applyCoupon(
                              couponController.text,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok
                                      ? 'Áp dụng mã thành công'
                                      : 'Mã giảm giá không hợp lệ',
                                ),
                              ),
                            );
                          },
                          child: const Text('Áp dụng'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  section(
                    title: 'Tóm tắt đơn hàng',
                    child: Column(
                      children: [
                        ...cart.items.map((item) {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.food.name} x${item.quantity}',
                                  ),
                                ),
                                Text('${formatPrice(item.total)} đ'),
                              ],
                            ),
                          );
                        }),
                        const Divider(),
                        row('Tạm tính', cart.subTotal),
                        row('Phí giao hàng', cart.deliveryFee),
                        if (cart.discountAmount > 0)
                          row('Giảm giá', -cart.discountAmount),
                        const Divider(),
                        row(
                          'Tổng thanh toán',
                          cart.finalTotal,
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: isLoading ? null : () => placeOrder(cart),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Đặt hàng - ${formatPrice(cart.finalTotal)} đ',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget section({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget row(String label, int value, {bool bold = false}) {
    final minus = value < 0;
    final price = value.abs();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            '${minus ? '-' : ''}${formatPrice(price)} đ',
            style: TextStyle(
              color: minus ? Colors.green : Colors.black,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}