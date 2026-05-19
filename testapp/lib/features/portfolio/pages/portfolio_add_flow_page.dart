// Last Updated: 2026-05-19
// 最后更新: 2026-05-19
//
// Module: Portfolio add flow page - 4-step manual entry wizard
// 模块: 添加持仓页 - 四步录入向导
//
// Dependencies: flutter/material.dart, portfolio_controller, portfolio_models, portfolio_calculator, portfolio_theme, portfolio_format
// 依赖: flutter/material.dart, portfolio_controller, portfolio_models, portfolio_calculator, portfolio_theme, portfolio_format
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/portfolio_controller.dart';
import '../domain/portfolio_calculator.dart';
import '../domain/portfolio_models.dart';
import '../utils/portfolio_format.dart';
import '../widgets/portfolio_theme.dart';

class PortfolioAddFlowPage extends StatefulWidget {
  const PortfolioAddFlowPage({super.key, this.editHolding});

  final PortfolioHolding? editHolding;

  @override
  State<PortfolioAddFlowPage> createState() => _PortfolioAddFlowPageState();
}

class _PortfolioAddFlowPageState extends State<PortfolioAddFlowPage> {
  int _step = 0;
  PortfolioAssetType _assetType = PortfolioAssetType.stock;
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _tradeDate = DateTime.now();
  String? _error;

  bool get _isEdit => widget.editHolding != null;

  @override
  void initState() {
    super.initState();
    final PortfolioHolding? edit = widget.editHolding;
    if (edit != null) {
      _assetType = edit.assetType;
      _symbolController.text = edit.symbol;
      _nameController.text = edit.name;
      _quantityController.text = _formatNum(edit.quantity);
      _priceController.text = _formatNum(edit.costPrice);
      _tradeDate = edit.tradeDate;
      _noteController.text = edit.note ?? '';
      _step = 1;
    }
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatNum(double v) =>
      v % 1 == 0 ? v.toStringAsFixed(0) : v.toString();

  double? _parseDouble(String raw) {
    final String t = raw.trim();
    if (t.isEmpty) {
      return null;
    }
    return double.tryParse(t.replaceAll(',', ''));
  }

  double get _previewMarketValue {
    final double? q = _parseDouble(_quantityController.text);
    final double? p = _parseDouble(_priceController.text);
    if (q == null || p == null || q <= 0 || p <= 0) {
      return 0;
    }
    return q * p;
  }

  double get _estimatedWeight {
    final List<PortfolioHolding> existing = portfolioController.holdings
        .where(
          (PortfolioHolding h) => h.id != widget.editHolding?.id,
        )
        .toList();
    return PortfolioCalculator.estimatedWeightForNew(
      existing: existing,
      newMarketValue: _previewMarketValue,
    );
  }

  bool _validateStep() {
    setState(() => _error = null);
    switch (_step) {
      case 1:
        if (_symbolController.text.trim().isEmpty ||
            _nameController.text.trim().isEmpty) {
          setState(() => _error = '请填写代码与名称');
          return false;
        }
      case 2:
        final double? q = _parseDouble(_quantityController.text);
        final double? p = _parseDouble(_priceController.text);
        if (q == null || p == null || q <= 0 || p <= 0) {
          setState(() => _error = '数量与单价须大于 0');
          return false;
        }
        final DateTime today = DateTime.now();
        final DateTime d = DateTime(
          _tradeDate.year,
          _tradeDate.month,
          _tradeDate.day,
        );
        final DateTime t = DateTime(today.year, today.month, today.day);
        if (d.isAfter(t)) {
          setState(() => _error = '成交日期不能晚于今天');
          return false;
        }
    }
    return true;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tradeDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: '选择成交日期',
    );
    if (picked != null) {
      setState(() => _tradeDate = picked);
    }
  }

  Future<void> _save() async {
    final double? q = _parseDouble(_quantityController.text);
    final double? p = _parseDouble(_priceController.text);
    if (q == null || p == null) {
      return;
    }
    final PortfolioHolding holding = PortfolioHolding(
      id: widget.editHolding?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      assetType: _assetType,
      symbol: _symbolController.text.trim(),
      name: _nameController.text.trim(),
      quantity: q,
      costPrice: p,
      lastPrice: widget.editHolding?.lastPrice ?? p,
      tradeDate: _tradeDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      dayChangePercent: widget.editHolding?.dayChangePercent,
    );
    await portfolioController.upsert(holding);
    if (!mounted) {
      return;
    }
    if (!_isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已保存。可随时在列表中修改成本或数量。'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    Navigator.of(context).pop(true);
  }

  Widget _dateField() {
    final String dateText =
        '${_tradeDate.year}-${_tradeDate.month.toString().padLeft(2, '0')}-${_tradeDate.day.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          '成交日期',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: PortfolioTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: PortfolioTheme.border),
              ),
              child: Text(
                dateText,
                style: const TextStyle(
                  fontSize: 15,
                  color: PortfolioTheme.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFBFE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: PortfolioTheme.textPrimary,
          onPressed: () {
            if (_step > 0 && !_isEdit) {
              setState(() => _step -= 1);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          _isEdit ? '编辑持仓' : '添加持仓',
          style: const TextStyle(
            color: PortfolioTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (!_isEdit) ...<Widget>[
                Text(
                  '第 ${_step + 1} 步 / 共 4 步',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: PortfolioTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(4, (int i) {
                    final bool active = i <= _step;
                    return Container(
                      width: i == _step ? 8 : 6,
                      height: i == _step ? 8 : 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? PortfolioTheme.primaryBlue
                            : const Color(0xFFD9DEE8),
                      ),
                    );
                  }),
                ),
              ],
              const SizedBox(height: 20),
              Expanded(child: _buildStepBody()),
              if (_error != null) ...<Widget>[
                Text(
                  _error!,
                  style: const TextStyle(color: PortfolioTheme.priceUp),
                ),
                const SizedBox(height: 8),
              ],
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody() {
    switch (_step) {
      case 0:
        return _buildTypeStep();
      case 1:
        return _buildSymbolStep();
      case 2:
        return _buildTradeStep();
      default:
        return _buildConfirmStep();
    }
  }

  Widget _buildTypeStep() {
    return ListView(
      children: <Widget>[
        const Text(
          '选择资产类型',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PortfolioTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...PortfolioAssetType.values.map(_typeCard),
      ],
    );
  }

  Widget _typeCard(PortfolioAssetType type) {
    final bool selected = _assetType == type;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? PortfolioTheme.previewBlueBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => setState(() => _assetType = type),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? PortfolioTheme.primaryBlue
                    : PortfolioTheme.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Text(
              type.labelZh,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PortfolioTheme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolStep() {
    return ListView(
      children: <Widget>[
        const Text(
          '标的代码与名称',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PortfolioTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _labeledField('代码', _symbolController, hint: '如 600519.SH'),
        const SizedBox(height: 12),
        _labeledField('名称', _nameController, hint: '如 贵州茅台'),
        const SizedBox(height: 12),
        _labeledField('备注（可选）', _noteController, hint: '如 华泰、定投'),
      ],
    );
  }

  Widget _buildTradeStep() {
    return ListView(
      children: <Widget>[
        const Text(
          '填写成交信息',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PortfolioTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _labeledField(
          '数量（股/份）',
          _quantityController,
          keyboard: TextInputType.number,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _labeledField(
          '成交单价',
          _priceController,
          keyboard: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _dateField(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: PortfolioTheme.previewBlueBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '预估组合占比',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: PortfolioTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '~ ${formatPortfolioPercent(_estimatedWeight, digits: 1)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: PortfolioTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmStep() {
    final double? q = _parseDouble(_quantityController.text);
    final double? p = _parseDouble(_priceController.text);
    return ListView(
      children: <Widget>[
        const Text(
          '确认保存',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PortfolioTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _summaryRow('类型', _assetType.labelZh),
        _summaryRow('标的', '${_nameController.text}（${_symbolController.text}）'),
        _summaryRow('数量', q?.toString() ?? '-'),
        _summaryRow('单价', p != null ? formatPortfolioCny(p) : '-'),
        _summaryRow(
          '成交日',
          '${_tradeDate.year}-${_tradeDate.month.toString().padLeft(2, '0')}-${_tradeDate.day.toString().padLeft(2, '0')}',
        ),
        _summaryRow(
          '预估占比',
          formatPortfolioPercent(_estimatedWeight, digits: 1),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: PortfolioTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PortfolioTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType? keyboard,
    bool readOnly = false,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: PortfolioTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboard,
          onChanged: onChanged,
          inputFormatters: keyboard == TextInputType.number ||
                  keyboard ==
                      const TextInputType.numberWithOptions(decimal: true)
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ]
              : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: PortfolioTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: PortfolioTheme.border),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    if (_step < 3) {
      return FilledButton(
        onPressed: () {
          if (_step > 0 && !_validateStep()) {
            return;
          }
          setState(() => _step += 1);
        },
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1F2438),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(_step == 0 ? '下一步' : '继续'),
      );
    }
    return FilledButton(
      onPressed: () async {
        if (!_validateStep()) {
          return;
        }
        await _save();
      },
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF1F2438),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: const Text('保存'),
    );
  }
}
