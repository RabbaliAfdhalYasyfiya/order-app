import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class FormFields extends StatelessWidget {
  const FormFields({
    super.key,
    required this.prefixIcon,
    required this.inputType,
    required this.controller,
    required this.hintText,
    required this.tap,
    required this.maxLineBoolean,
    required this.textInputFormatter,
    required this.focusNode,
    required this.onFieldSubmit,
  });

  final IconData prefixIcon;
  final TextInputType inputType;
  final TextEditingController controller;
  final String hintText;
  final bool tap;
  final bool maxLineBoolean;
  final TextInputFormatter textInputFormatter;
  final FocusNode focusNode;
  final Function(String) onFieldSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmit,
          maxLines: maxLineBoolean ? 3 : null,
          readOnly: tap,
          onChanged: (value) {
            controller.text = value;
          },
          controller: controller,
          inputFormatters: [
            textInputFormatter,
          ],
          keyboardType: inputType,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
          ),
          selectionControls: EmptyTextSelectionControls(),
          enableInteractiveSelection: true,
          canRequestFocus: true,
          showCursor: false,
          cursorColor: Theme.of(context).colorScheme.primary,
          obscureText: false,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                prefixIcon,
                color: Colors.grey.shade500,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1.5,
                style: BorderStyle.solid,
                color: Theme.of(context).primaryColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class FormFieldsPassword extends StatelessWidget {
  const FormFieldsPassword({
    super.key,
    required this.prefixIcon,
    required this.inputType,
    required this.controller,
    required this.hintText,
    required this.tap,
    required this.textInputFormatter,
    required this.focusNode,
    required this.onFieldSubmit,
    required this.obscure,
    required this.onTap,
  });

  final IconData prefixIcon;
  final TextInputType inputType;
  final TextEditingController controller;
  final String hintText;
  final bool tap;
  final bool obscure;
  final TextInputFormatter textInputFormatter;
  final FocusNode focusNode;
  final Function(String) onFieldSubmit;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmit,
          readOnly: tap,
          onChanged: (value) {
            controller.text = value;
          },
          controller: controller,
          inputFormatters: [
            textInputFormatter,
          ],
          keyboardType: inputType,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
          ),
          selectionControls: EmptyTextSelectionControls(),
          enableInteractiveSelection: true,
          canRequestFocus: true,
          showCursor: false,
          cursorColor: Theme.of(context).colorScheme.primary,
          obscureText: !obscure,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                prefixIcon,
                color: Colors.grey.shade500,
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: onTap,
                visualDensity: VisualDensity.comfortable,
                icon: Icon(
                  obscure ? Iconsax.eye_outline : Iconsax.eye_slash_outline,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1.5,
                style: BorderStyle.solid,
                color: Theme.of(context).primaryColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class FormFieldsKategori extends StatefulWidget {
  const FormFieldsKategori({
    super.key,
    required this.prefixIcon,
    required this.inputType,
    required this.controller,
    required this.manualController,
    required this.hintText,
    required this.tap,
    required this.maxLineBoolean,
    required this.textInputFormatter,
    required this.focusNode,
    required this.onFieldSubmit,
    required this.kategori,
  });

  final IconData prefixIcon;
  final TextInputType inputType;
  final TextEditingController controller;
  final TextEditingController manualController;
  final String hintText;
  final bool tap;
  final bool maxLineBoolean;
  final TextInputFormatter textInputFormatter;
  final FocusNode focusNode;
  final Function(String) onFieldSubmit;
  final List<String> kategori;

  @override
  State<FormFieldsKategori> createState() => _FormFieldsKategoriState();
}

class _FormFieldsKategoriState extends State<FormFieldsKategori> {
  String? selectKategori;
  bool isManualEntry = false;

  final FocusNode manualFocusNode = FocusNode();

  @override
  void dispose() {
    manualFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: isManualEntry
            ? TextFormField(
                focusNode: manualFocusNode,
                onFieldSubmitted: widget.onFieldSubmit,
                maxLines: widget.maxLineBoolean ? 3 : null,
                readOnly: widget.tap,
                onChanged: (value) {
                  widget.manualController.text = value;
                },
                controller: widget.manualController,
                inputFormatters: [
                  widget.textInputFormatter,
                ],
                keyboardType: widget.inputType,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w400,
                ),
                selectionControls: EmptyTextSelectionControls(),
                enableInteractiveSelection: true,
                canRequestFocus: true,
                showCursor: false,
                cursorColor: Theme.of(context).colorScheme.primary,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      widget.prefixIcon,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            : DropdownMenu(
                textStyle: const TextStyle(color: Colors.black),
                trailingIcon: const Icon(
                  Iconsax.arrow_down_bold,
                  color: Colors.black,
                  size: 20,
                ),
                selectedTrailingIcon: const Icon(
                  Iconsax.arrow_up_1_bold,
                  color: Colors.black,
                  size: 20,
                ),
                dropdownMenuEntries: <DropdownMenuEntry<String>>[
                  ...widget.kategori.map(
                    (category) {
                      return DropdownMenuEntry(
                        value: category,
                        label: category,
                        labelWidget: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        leadingIcon: const Icon(
                          Iconsax.settings_outline,
                          color: Colors.black,
                        ),
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                          visualDensity: VisualDensity.standard,
                          iconSize: const WidgetStatePropertyAll(20),
                          fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.infinity)),
                          textStyle: const WidgetStatePropertyAll(
                            TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const DropdownMenuEntry(
                    value: 'Other',
                    label: 'Kategori Lainnya',
                    labelWidget: Text(
                      'Kategori Lainnya',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leadingIcon: Icon(
                      Iconsax.edit_outline,
                      color: Colors.black,
                    ),
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      visualDensity: VisualDensity.standard,
                      iconSize: WidgetStatePropertyAll(20),
                      fixedSize: WidgetStatePropertyAll(Size.fromWidth(double.infinity)),
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
                hintText: widget.hintText,
                leadingIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    widget.prefixIcon,
                    color: Colors.grey.shade500,
                  ),
                ),
                controller: widget.controller,
                menuStyle: MenuStyle(
                  visualDensity: VisualDensity.compact,
                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
                  backgroundColor:
                      WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
                  elevation: const WidgetStatePropertyAll(2),
                  shadowColor: WidgetStatePropertyAll(Theme.of(context).shadowColor),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(width: 1, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
                width: double.infinity,
                onSelected: (value) {
                  setState(() {
                    if (value == 'Other') {
                      isManualEntry = true;
                      widget.controller.clear();
                      widget.manualController.clear();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(manualFocusNode);
                      });
                    } else {
                      isManualEntry = false;
                      selectKategori = value;
                      widget.controller.text = value ?? '';
                    }
                  });
                },
              ),
      ),
    );
  }
}
