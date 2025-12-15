import 'package:flutter/material.dart';
import '../../data/model/category_model.dart';
import '../../data/repository/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Charger toutes les catégories actives
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getActiveCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sélectionner une catégorie
  void selectCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Réinitialiser la sélection
  void clearSelection() {
    _selectedCategory = null;
    notifyListeners();
  }
}
