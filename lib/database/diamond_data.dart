class Diamond {
  String shape;
  String clarity;
  String color;
  double caratFrom;
  double caratTo;
  double price;
  String expiryDate;

  Diamond(this.shape, this.clarity, this.color, this.caratFrom, this.caratTo,
      this.price, this.expiryDate);

  Map<String, dynamic> toMap() {
    return {
      'shape': shape,
      'clarity': clarity,
      'color': color,
      'carat_from': caratFrom,
      'carat_to': caratTo,
      'price': price,
      'expiry_date': expiryDate,
    };
  }
}
