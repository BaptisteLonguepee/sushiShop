import 'package:flutter/material.dart';
import '../../../core/constant/color.dart';
import '../../../l10n/app_localizations.dart';
import '../model/order_type_model.dart';
import '../viewmodel/order_type_viewmodel.dart';

class OrderTypeScreen extends StatefulWidget {
  const OrderTypeScreen({super.key});

  @override
  State<OrderTypeScreen> createState() => _OrderTypeScreenState();
}

class _OrderTypeScreenState extends State<OrderTypeScreen> {
  late final OrderTypeViewModel _viewModel;
  final TextEditingController _tableNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = OrderTypeViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _tableNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          localizations?.order_type_title ?? 'Type de commande',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations?.order_type_question ?? 'Comment souhaitez-vous commander ?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Bouton Sur Place
              _buildOrderTypeButton(
                context,
                type: OrderType.dineIn,
                icon: Icons.restaurant,
                label: localizations?.order_type_dine_in ?? 'Sur Place',
                isSelected: _viewModel.selectedOrderType == OrderType.dineIn,
              ),
              
              const SizedBox(height: 20),
              
              // Bouton À Emporter
              _buildOrderTypeButton(
                context,
                type: OrderType.takeaway,
                icon: Icons.shopping_bag,
                label: localizations?.order_type_takeaway ?? 'À Emporter',
                isSelected: _viewModel.selectedOrderType == OrderType.takeaway,
              ),
              
              const SizedBox(height: 32),
              
              // Champ pour le numéro de chevalet (si Sur Place)
              AnimatedOpacity(
                opacity: _viewModel.selectedOrderType == OrderType.dineIn ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _viewModel.selectedOrderType == OrderType.dineIn ? null : 0,
                  child: _viewModel.selectedOrderType == OrderType.dineIn
                      ? Column(
                          children: [
                            Text(
                              localizations?.order_type_table_number ?? 'Numéro de chevalet',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _tableNumberController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: localizations?.order_type_enter_table_number ?? 'Entrez le numéro',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                              ),
                              onChanged: (value) {
                                final number = int.tryParse(value);
                                _viewModel.setTableNumber(number);
                              },
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              
              const Spacer(),
              
              // Bouton Continuer
              ElevatedButton(
                onPressed: _viewModel.isValid
                    ? () => _viewModel.validateAndNavigate(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColor.cardColor,
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _viewModel.isValid ? 4 : 0,
                ),
                child: Text(
                  localizations?.order_type_continue ?? 'Continuer',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTypeButton(
    BuildContext context, {
    required OrderType type,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _viewModel.selectOrderType(type),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : AppColor.cardColor,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColor.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : AppColor.primaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
