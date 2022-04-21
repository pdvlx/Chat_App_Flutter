import 'package:flutter/material.dart';

class PaddingButton extends StatelessWidget {
  PaddingButton(this._color, this._function, this._titleText);

  final Color _color;
  final Function _function;
  final String _titleText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: _color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: _function,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            _titleText,
          ),
        ),
      ),
    );
  }
}
