import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DiamondData {
  final String stockNum;
  final String availability;
  final String shape;
  final String size;
  final String color;
  final String? fancyColor;
  final String? fancyColorIntensity;
  final String? fancyColorOvertone;
  final String? clarity;
  final String? cut;
  final String? polish;
  final String? symmetry;
  final String? fluorIntensity;
  final String? fluorColor;
  final String? lab;
  final String? measurement;
  final String? certNum;
  final String? depthPercent;
  final String? tablePercent;
  final String? rapPrice;
  final String? discountPercent;
  final String? pricePerCara;
  final String? totalSalesPrice;
  final String? videoUrl;
  final String? certUrl;
  final String? imageUrl;
  final String? comments;
  final String? certComment;
  final String? city;
  final String? state;
  final String? country;
  final String? crownAngle;
  final String? crownHeight;
  final String? pavilionDepth;
  final String? pavilionAngle;
  final String? girdlePercent;
  final String? girdleMin;
  final String? girdleMax;
  final String? girdleCondition;
  final String? ratio;
  final String? diamondType;
  final String? bgm;
  final String? culetSize;
  final String? culetCondition;
  final String? inclusionCenter;
  final String? milky;
  final String? setMatchedPairSeparable;
  final String? treatment;
  final String? tradeShow;
  final String? shade;
  final String? laserInscription;
  final String? cameraRef;
  final String? cashDiscount;
  final String? cashPrice;
  final String? pairStockNum;
  final String? parcelStones;
  final String? eyeClean;
  final String? starLength;
  final String? inclusionBlack;
  final String? inclusionOpen;
  final String? cameraType;
  final String? fancyColorSecondaryColor;

  DiamondData({
    required this.stockNum,
    required this.availability,
    required this.shape,
    required this.size,
    required this.color,
    required this.fancyColor,
    required this.fancyColorIntensity,
    required this.fancyColorOvertone,
    required this.clarity,
    required this.cut,
    required this.polish,
    required this.symmetry,
    required this.fluorIntensity,
    required this.fluorColor,
    required this.lab,
    required this.measurement,
    required this.certNum,
    required this.depthPercent,
    required this.tablePercent,
    required this.rapPrice,
    required this.discountPercent,
    required this.pricePerCara,
    required this.totalSalesPrice,
    required this.videoUrl,
    required this.certUrl,
    required this.imageUrl,
    required this.comments,
    required this.certComment,
    required this.city,
    required this.state,
    required this.country,
    required this.crownAngle,
    required this.crownHeight,
    required this.pavilionDepth,
    required this.pavilionAngle,
    required this.girdlePercent,
    required this.girdleMin,
    required this.girdleMax,
    required this.girdleCondition,
    required this.ratio,
    required this.diamondType,
    required this.bgm,
    required this.culetSize,
    required this.culetCondition,
    required this.inclusionCenter,
    required this.milky,
    required this.setMatchedPairSeparable,
    required this.treatment,
    required this.tradeShow,
    required this.shade,
    required this.laserInscription,
    required this.cameraRef,
    required this.cashDiscount,
    required this.cashPrice,
    required this.pairStockNum,
    required this.parcelStones,
    required this.eyeClean,
    required this.starLength,
    required this.inclusionBlack,
    required this.inclusionOpen,
    required this.cameraType,
    required this.fancyColorSecondaryColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'stock_num': stockNum,
      'availability': availability,
      'shape': shape,
      'size': size,
      'color': color,
      'fancy_color': fancyColor,
      'fancy_color_intensity': fancyColorIntensity,
      'fancy_color_overtone': fancyColorOvertone,
      'clarity': clarity,
      'cut': cut,
      'polish': polish,
      'symmetry': symmetry,
      'fluor_intensity': fluorIntensity,
      'fluor_color': fluorColor,
      'lab': lab,
      'measurement': measurement,
      'cert_num': certNum,
      'depth_percent': depthPercent,
      'table_percent': tablePercent,
      'Rap_price': rapPrice,
      'discount_percent': discountPercent,
      'price_per_cara': pricePerCara,
      'total_sales_price': totalSalesPrice,
      'video_url': videoUrl,
      'cert_url': certUrl,
      'image_url': imageUrl,
      'comments': comments,
      'cert_comment': certComment,
      'city': city,
      'state': state,
      'country': country,
      'crown_angle': crownAngle,
      'crown_height': crownHeight,
      'pavilion_depth': pavilionDepth,
      'pavilion_angle': pavilionAngle,
      'girdle_percent': girdlePercent,
      'girdle_min': girdleMin,
      'girdle_max': girdleMax,
      'girdle_condition': girdleCondition,
      'ratio': ratio,
      'DiamondType': diamondType,
      'bgm': bgm,
      'culet_size': culetSize,
      'culet_condition': culetCondition,
      'inclusion_center': inclusionCenter,
      'milky': milky,
      'set_matched_pair_separable': setMatchedPairSeparable,
      'treatment': treatment,
      'trade_show': tradeShow,
      'shade': shade,
      'laser_inscription': laserInscription,
      'camera_ref': cameraRef,
      'cash_discount': cashDiscount,
      'cash_price': cashPrice,
      'pair_stock_num': pairStockNum,
      'parcel_stones': parcelStones,
      'eye_clean': eyeClean,
      'star_length': starLength,
      'inclusion_black': inclusionBlack,
      'inclusion_open': inclusionOpen,
      'camera_type': cameraType,
      'fancy_color_secondary_color': fancyColorSecondaryColor,
    };
  }

  factory DiamondData.fromJson(Map<String, dynamic> json) {
    return DiamondData(
      stockNum: json['stock_num'],
      availability: json['availability'],
      shape: json['shape'],
      size: json['size'],
      color: json['color'],
      fancyColor: json['fancy_color'],
      fancyColorIntensity: json['fancy_color_intensity'],
      fancyColorOvertone: json['fancy_color_overtone'],
      clarity: json['clarity'],
      cut: json['cut'],
      polish: json['polish'],
      symmetry: json['symmetry'],
      fluorIntensity: json['fluor_intensity'],
      fluorColor: json['fluor_color'],
      lab: json['lab'],
      measurement: json['measurement'],
      certNum: json['cert_num'],
      depthPercent: json['depth_percent'],
      tablePercent: json['table_percent'],
      rapPrice: json['Rap_price'],
      discountPercent: json['discount_percent'],
      pricePerCara: json['price_per_cara'],
      totalSalesPrice: json['total_sales_price'],
      videoUrl: json['video_url'],
      certUrl: json['cert_url'],
      imageUrl: json['image_url'],
      comments: json['comments'],
      certComment: json['cert_comment'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      crownAngle: json['crown_angle'],
      crownHeight: json['crown_height'],
      pavilionDepth: json['pavilion_depth'],
      pavilionAngle: json['pavilion_angle'],
      girdlePercent: json['girdle_percent'],
      girdleMin: json['girdle_min'],
      girdleMax: json['girdle_max'],
      girdleCondition: json['girdle_condition'],
      ratio: json['ratio'],
      diamondType: json['DiamondType'],
      bgm: json['bgm'],
      culetSize: json['culet_size'],
      culetCondition: json['culet_condition'],
      inclusionCenter: json['inclusion_center'],
      milky: json['milky'],
      setMatchedPairSeparable: json['set_matched_pair_separable'],
      treatment: json['treatment'],
      tradeShow: json['trade_show'],
      shade: json['shade'],
      laserInscription: json['laser_inscription'],
      cameraRef: json['camera_ref'],
      cashDiscount: json['cash_discount'],
      cashPrice: json['cash_price'],
      pairStockNum: json['pair_stock_num'],
      parcelStones: json['parcel_stones'],
      eyeClean: json['eye_clean'],
      starLength: json['star_length'],
      inclusionBlack: json['inclusion_black'],
      inclusionOpen: json['inclusion_open'],
      cameraType: json['camera_type'],
      fancyColorSecondaryColor: json['fancy_color_secondary_color'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'stock_diamond_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int newVersion) async {
    await db.execute('''
    CREATE TABLE diamonds(
      stock_num TEXT PRIMARY KEY,
      availability TEXT,
      shape TEXT,
      size TEXT,
      color TEXT,
      fancy_color TEXT,
      fancy_color_intensity TEXT,
      fancy_color_overtone TEXT,
      clarity TEXT,
      cut TEXT,
      polish TEXT,
      symmetry TEXT,
      fluor_intensity TEXT,
      fluor_color TEXT,
      lab TEXT,
      measurement TEXT,
      cert_num TEXT,
      depth_percent TEXT,
      table_percent TEXT,
      Rap_price TEXT,
      discount_percent TEXT,
      price_per_cara TEXT,
      total_sales_price TEXT,
      video_url TEXT,
      cert_url TEXT,
      image_url TEXT,
      comments TEXT,
      cert_comment TEXT,
      city TEXT,
      state TEXT,
      country TEXT,
      crown_angle TEXT,
      crown_height TEXT,
      pavilion_depth TEXT,
      pavilion_angle TEXT,
      girdle_percent TEXT,
      girdle_min TEXT,
      girdle_max TEXT,
      girdle_condition TEXT,
      ratio TEXT,
      DiamondType TEXT,
      bgm TEXT,
      culet_size TEXT,
      culet_condition TEXT,
      inclusion_center TEXT,
      milky TEXT,
      set_matched_pair_separable TEXT,
      treatment TEXT,
      trade_show TEXT,
      shade TEXT,
      laser_inscription TEXT,
      camera_ref TEXT,
      cash_discount TEXT,
      cash_price TEXT,
      pair_stock_num TEXT,
      parcel_stones TEXT,
      eye_clean TEXT,
      star_length TEXT,
      inclusion_black TEXT,
      inclusion_open TEXT,
      camera_type TEXT,
      fancy_color_secondary_color TEXT
    )
  ''');
  }

  Future<int> getDiamondCountByType(String type) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM diamonds WHERE DiamondType = ?', [type]));
    return count ?? 0;
  }

  Future<List<DiamondData>> getDiamondsByShape(String shape) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diamonds',
      where: 'shape = ?',
      whereArgs: [shape],
    );

    return List.generate(maps.length, (i) {
      return DiamondData(
        stockNum: maps[i]['stock_num'],
        shape: maps[i]['shape'],
        size: maps[i]['size'],
        imageUrl: maps[i]['image_url'],
        availability: maps[i]['availability'],
        setMatchedPairSeparable: maps[i]['set_matched_pair_separable'],
        depthPercent: maps[i]['depth_percent'],
        diamondType: maps[i]['DiamondType'],
        discountPercent: maps[i]['discount_percent'],
        cashDiscount: maps[i]['cash_discount'],
        cashPrice: maps[i]['cash_price'],
        pavilionDepth: maps[i]['pavilion_depth'],
        pavilionAngle: maps[i]['pavilion_angle'],
        girdlePercent: maps[i]['girdle_percent'],
        girdleMin: maps[i]['girdle_min'],
        girdleMax: maps[i]['girdle_max'],
        girdleCondition: maps[i]['girdle_condition'],
        ratio: maps[i]['ratio'],
        crownAngle: maps[i]['crown_angle'],
        crownHeight: maps[i]['crown_height'],
        fluorIntensity: maps[i]['fluor_intensity'],
        fluorColor: maps[i]['fluor_color'],
        lab: maps[i]['lab'],
        measurement: maps[i]['measurement'],
        certNum: maps[i]['cert_num'],
        tablePercent: maps[i]['table_percent'],
        rapPrice: maps[i]['Rap_price'],
        pricePerCara: maps[i]['price_per_cara'],
        totalSalesPrice: maps[i]['total_sales_price'],
        videoUrl: maps[i]['video_url'],
        certUrl: maps[i]['cert_url'],
        comments: maps[i]['comments'],
        certComment: maps[i]['cert_comment'],
        city: maps[i]['city'],
        state: maps[i]['state'],
        country: maps[i]['country'],
        culetSize: maps[i]['culet_size'],
        culetCondition: maps[i]['culet_condition'],
        inclusionCenter: maps[i]['inclusion_center'],
        milky: maps[i]['milky'],
        treatment: maps[i]['treatment'],
        tradeShow: maps[i]['trade_show'],
        shade: maps[i]['shade'],
        laserInscription: maps[i]['laser_inscription'],
        cameraRef: maps[i]['camera_ref'],
        pairStockNum: maps[i]['pair_stock_num'],
        parcelStones: maps[i]['parcel_stones'],
        eyeClean: maps[i]['eye_clean'],
        starLength: maps[i]['star_length'],
        inclusionBlack: maps[i]['inclusion_black'],
        inclusionOpen: maps[i]['inclusion_open'],
        cameraType: maps[i]['camera_type'],
        fancyColor: maps[i]['fancy_color'],
        fancyColorIntensity: maps[i]['fancy_color_intensity'],
        fancyColorOvertone: maps[i]['fancy_color_overtone'],
        color: maps[i]['color'],
        symmetry: maps[i]['symmetry'],
        cut: maps[i]['cut'],
        polish: maps[i]['polish'],
        clarity: maps[i]['clarity'],
        bgm: maps[i]['bgm'],
        fancyColorSecondaryColor: maps[i]['fancy_color_secondary_color'],
        // Add other fields similarly
      );
    });
  }

  Future<int> getDiamondCountByShape(String shape) async {
    final db = await database;
    final List<Map<String, dynamic>> count = await db.rawQuery(
      'SELECT COUNT(*) FROM diamonds WHERE shape = ?',
      [shape],
    );

    return Sqflite.firstIntValue(count) ?? 0;
  }

  Future<List<DiamondData>> getDiamondsByClarity(String clarity) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diamonds',
      where: 'clarity = ?',
      whereArgs: [clarity],
    );

    return List.generate(maps.length, (i) {
      return DiamondData(
        stockNum: maps[i]['stock_num'],
        shape: maps[i]['shape'],
        size: maps[i]['size'],
        imageUrl: maps[i]['image_url'],
        availability: maps[i]['availability'],
        setMatchedPairSeparable: maps[i]['set_matched_pair_separable'],
        depthPercent: maps[i]['depth_percent'],
        diamondType: maps[i]['DiamondType'],
        discountPercent: maps[i]['discount_percent'],
        cashDiscount: maps[i]['cash_discount'],
        cashPrice: maps[i]['cash_price'],
        pavilionDepth: maps[i]['pavilion_depth'],
        pavilionAngle: maps[i]['pavilion_angle'],
        girdlePercent: maps[i]['girdle_percent'],
        girdleMin: maps[i]['girdle_min'],
        girdleMax: maps[i]['girdle_max'],
        girdleCondition: maps[i]['girdle_condition'],
        ratio: maps[i]['ratio'],
        crownAngle: maps[i]['crown_angle'],
        crownHeight: maps[i]['crown_height'],
        fluorIntensity: maps[i]['fluor_intensity'],
        fluorColor: maps[i]['fluor_color'],
        lab: maps[i]['lab'],
        measurement: maps[i]['measurement'],
        certNum: maps[i]['cert_num'],
        tablePercent: maps[i]['table_percent'],
        rapPrice: maps[i]['Rap_price'],
        pricePerCara: maps[i]['price_per_cara'],
        totalSalesPrice: maps[i]['total_sales_price'],
        videoUrl: maps[i]['video_url'],
        certUrl: maps[i]['cert_url'],
        comments: maps[i]['comments'],
        certComment: maps[i]['cert_comment'],
        city: maps[i]['city'],
        state: maps[i]['state'],
        country: maps[i]['country'],
        culetSize: maps[i]['culet_size'],
        culetCondition: maps[i]['culet_condition'],
        inclusionCenter: maps[i]['inclusion_center'],
        milky: maps[i]['milky'],
        treatment: maps[i]['treatment'],
        tradeShow: maps[i]['trade_show'],
        shade: maps[i]['shade'],
        laserInscription: maps[i]['laser_inscription'],
        cameraRef: maps[i]['camera_ref'],
        pairStockNum: maps[i]['pair_stock_num'],
        parcelStones: maps[i]['parcel_stones'],
        eyeClean: maps[i]['eye_clean'],
        starLength: maps[i]['star_length'],
        inclusionBlack: maps[i]['inclusion_black'],
        inclusionOpen: maps[i]['inclusion_open'],
        cameraType: maps[i]['camera_type'],
        fancyColor: maps[i]['fancy_color'],
        fancyColorIntensity: maps[i]['fancy_color_intensity'],
        fancyColorOvertone: maps[i]['fancy_color_overtone'],
        color: maps[i]['color'],
        symmetry: maps[i]['symmetry'],
        cut: maps[i]['cut'],
        polish: maps[i]['polish'],
        clarity: maps[i]['clarity'],
        bgm: maps[i]['bgm'],
        fancyColorSecondaryColor: maps[i]['fancy_color_secondary_color'],
        // Add other fields similarly
      );
    });
  }

  Future<int> getDiamondCountByClarity(String clarity) async {
    final db = await database;
    final List<Map<String, dynamic>> count = await db.rawQuery(
      'SELECT COUNT(*) FROM diamonds WHERE clarity = ?',
      [clarity],
    );

    return Sqflite.firstIntValue(count) ?? 0;
  }

  Future<List<DiamondData>> getDiamondsByColor(String color) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diamonds',
      where: 'color = ?',
      whereArgs: [color],
    );

    return List.generate(maps.length, (i) {
      return DiamondData(
        stockNum: maps[i]['stock_num'],
        shape: maps[i]['shape'],
        size: maps[i]['size'],
        imageUrl: maps[i]['image_url'],
        availability: maps[i]['availability'],
        setMatchedPairSeparable: maps[i]['set_matched_pair_separable'],
        depthPercent: maps[i]['depth_percent'],
        diamondType: maps[i]['DiamondType'],
        discountPercent: maps[i]['discount_percent'],
        cashDiscount: maps[i]['cash_discount'],
        cashPrice: maps[i]['cash_price'],
        pavilionDepth: maps[i]['pavilion_depth'],
        pavilionAngle: maps[i]['pavilion_angle'],
        girdlePercent: maps[i]['girdle_percent'],
        girdleMin: maps[i]['girdle_min'],
        girdleMax: maps[i]['girdle_max'],
        girdleCondition: maps[i]['girdle_condition'],
        ratio: maps[i]['ratio'],
        crownAngle: maps[i]['crown_angle'],
        crownHeight: maps[i]['crown_height'],
        fluorIntensity: maps[i]['fluor_intensity'],
        fluorColor: maps[i]['fluor_color'],
        lab: maps[i]['lab'],
        measurement: maps[i]['measurement'],
        certNum: maps[i]['cert_num'],
        tablePercent: maps[i]['table_percent'],
        rapPrice: maps[i]['Rap_price'],
        pricePerCara: maps[i]['price_per_cara'],
        totalSalesPrice: maps[i]['total_sales_price'],
        videoUrl: maps[i]['video_url'],
        certUrl: maps[i]['cert_url'],
        comments: maps[i]['comments'],
        certComment: maps[i]['cert_comment'],
        city: maps[i]['city'],
        state: maps[i]['state'],
        country: maps[i]['country'],
        culetSize: maps[i]['culet_size'],
        culetCondition: maps[i]['culet_condition'],
        inclusionCenter: maps[i]['inclusion_center'],
        milky: maps[i]['milky'],
        treatment: maps[i]['treatment'],
        tradeShow: maps[i]['trade_show'],
        shade: maps[i]['shade'],
        laserInscription: maps[i]['laser_inscription'],
        cameraRef: maps[i]['camera_ref'],
        pairStockNum: maps[i]['pair_stock_num'],
        parcelStones: maps[i]['parcel_stones'],
        eyeClean: maps[i]['eye_clean'],
        starLength: maps[i]['star_length'],
        inclusionBlack: maps[i]['inclusion_black'],
        inclusionOpen: maps[i]['inclusion_open'],
        cameraType: maps[i]['camera_type'],
        fancyColor: maps[i]['fancy_color'],
        fancyColorIntensity: maps[i]['fancy_color_intensity'],
        fancyColorOvertone: maps[i]['fancy_color_overtone'],
        color: maps[i]['color'],
        symmetry: maps[i]['symmetry'],
        cut: maps[i]['cut'],
        polish: maps[i]['polish'],
        clarity: maps[i]['clarity'],
        bgm: maps[i]['bgm'],
        fancyColorSecondaryColor: maps[i]['fancy_color_secondary_color'],
        // Add other fields similarly
      );
    });
  }

  Future<int> getDiamondCountByColor(String color) async {
    final db = await database;
    final List<Map<String, dynamic>> count = await db.rawQuery(
      'SELECT COUNT(*) FROM diamonds WHERE color = ?',
      [color],
    );

    return Sqflite.firstIntValue(count) ?? 0;
  }

  Future<List<DiamondData>> getDiamondsByType(String diamondType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diamonds',
      where: 'DiamondType = ?',
      whereArgs: [diamondType],
    );
    print('Diamonds retrieved from database: $maps');

    return List.generate(maps.length, (i) {
      return DiamondData(
        // Map each row of the result to a DiamondData object
        stockNum: maps[i]['stock_num'],
        shape: maps[i]['shape'],
        size: maps[i]['size'],
        imageUrl: maps[i]['image_url'],
        availability: maps[i]['availability'],
        setMatchedPairSeparable: maps[i]['set_matched_pair_separable'],
        depthPercent: maps[i]['depth_percent'],
        diamondType: maps[i]['DiamondType'],
        discountPercent: maps[i]['discount_percent'],
        cashDiscount: maps[i]['cash_discount'],
        cashPrice: maps[i]['cash_price'],
        pavilionDepth: maps[i]['pavilion_depth'],
        pavilionAngle: maps[i]['pavilion_angle'],
        girdlePercent: maps[i]['girdle_percent'],
        girdleMin: maps[i]['girdle_min'],
        girdleMax: maps[i]['girdle_max'],
        girdleCondition: maps[i]['girdle_condition'],
        ratio: maps[i]['ratio'],
        crownAngle: maps[i]['crown_angle'],
        crownHeight: maps[i]['crown_height'],
        fluorIntensity: maps[i]['fluor_intensity'],
        fluorColor: maps[i]['fluor_color'],
        lab: maps[i]['lab'],
        measurement: maps[i]['measurement'],
        certNum: maps[i]['cert_num'],
        tablePercent: maps[i]['table_percent'],
        rapPrice: maps[i]['Rap_price'],
        pricePerCara: maps[i]['price_per_cara'],
        totalSalesPrice: maps[i]['total_sales_price'],
        videoUrl: maps[i]['video_url'],
        certUrl: maps[i]['cert_url'],
        comments: maps[i]['comments'],
        certComment: maps[i]['cert_comment'],
        city: maps[i]['city'],
        state: maps[i]['state'],
        country: maps[i]['country'],
        culetSize: maps[i]['culet_size'],
        culetCondition: maps[i]['culet_condition'],
        inclusionCenter: maps[i]['inclusion_center'],
        milky: maps[i]['milky'],
        treatment: maps[i]['treatment'],
        tradeShow: maps[i]['trade_show'],
        shade: maps[i]['shade'],
        laserInscription: maps[i]['laser_inscription'],
        cameraRef: maps[i]['camera_ref'],
        pairStockNum: maps[i]['pair_stock_num'],
        parcelStones: maps[i]['parcel_stones'],
        eyeClean: maps[i]['eye_clean'],
        starLength: maps[i]['star_length'],
        inclusionBlack: maps[i]['inclusion_black'],
        inclusionOpen: maps[i]['inclusion_open'],
        cameraType: maps[i]['camera_type'],
        fancyColor: maps[i]['fancy_color'],
        fancyColorIntensity: maps[i]['fancy_color_intensity'],
        fancyColorOvertone: maps[i]['fancy_color_overtone'],
        color: maps[i]['color'],
        symmetry: maps[i]['symmetry'],
        cut: maps[i]['cut'],
        polish: maps[i]['polish'],
        clarity: maps[i]['clarity'],
        bgm: maps[i]['bgm'],
        fancyColorSecondaryColor: maps[i]['fancy_color_secondary_color'],

        // Assign other properties similarly
        // ...
      );
    });
  }

  Future<void> insertDiamond(DiamondData diamond) async {
    final db = await database;
    try {
      await db.insert('diamonds', diamond.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      print('Error inserting diamond: $e');
      // Handle the error as needed
    }
  }

  // Implement other database operations as needed
}

class DataManager {
  final String apiUrl = 'http://110.227.193.129:805/?APIKEY=cvd';

  Future<void> fetchDataAndStore({bool createIfNotExists = false}) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      for (final item in jsonData) {
        final DiamondData diamond = DiamondData.fromJson(item);
        await DatabaseHelper().insertDiamond(diamond);
      }
      print("Data fetched and stored successfully from API.");
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<bool> isDatabaseExists() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'stock_diamond_database.db');
    print("Database path: $path");
    return File(path).exists();
  }

  Future<void> refreshDatabase() async {
    final bool exists = await isDatabaseExists();
    if (!exists) {
      await fetchDataAndStore(createIfNotExists: true);
      print(
          "Database created and data fetched and stored successfully. Refresh ");
    } else {
      await fetchDataAndStore();
      print("Data fetched and stored successfully. Refreshing database. ");
    }
  }
}
