part of search_map_place;

class SearchMapPlaceWidget extends StatefulWidget {

  const SearchMapPlaceWidget({
    required this.apiKey,
    required this.onSelected, this.placeholder,
    this.icon = Icons.search,
    this.hasClearButton = true,
    this.clearIcon = Icons.clear,
    this.iconColor = kSecondaryColor,
    this.onSearch,
    this.language = 'pt',
    this.location,
    this.radius,
    this.strictBounds = false,
    this.placeType,
    this.darkMode = false,
    this.key,
  })  : assert((location == null && radius == null) ||
            (location != null && radius != null),),
        super(key: key);
  @override
  final Key? key;

  /// API Key of the Google Maps API.
  final String apiKey;

  /// Placeholder text to show when the user has not entered any input.
  final String? placeholder;

  /// The callback that is called when one Place is selected by the user.
  final void Function(Place place) onSelected;

  /// The callback that is called when the user taps on the search icon.
  final void Function(Place place)? onSearch;

  /// Language used for the autocompletion.
  ///
  /// Check the full list of [supported languages](https://developers.google.com/maps/faq#languagesupport) for the Google Maps API
  final String language;

  /// The point around which you wish to retrieve place information.
  ///
  /// If this value is provided, `radius` must be provided aswell.
  final LatLng? location;

  /// The distance (in meters) within which to return place results. Note that setting a radius biases results to the indicated area, but may not fully restrict results to the specified area.
  ///
  /// If this value is provided, `location` must be provided aswell.
  ///
  /// See [Location Biasing and Location Restrict](https://developers.google.com/places/web-service/autocomplete#location_biasing) in the documentation.
  final int? radius;

  /// Returns only those places that are strictly within the region defined by location and radius. This is a restriction, rather than a bias, meaning that results outside this region will not be returned even if they match the user input.
  final bool strictBounds;

  /// Place type to filter the search. This is a tool that can be used if you only want to search for a specific type of location. If this no place type is provided, all types of places are searched. For more info on location types, check https://developers.google.com/places/web-service/autocomplete?#place_types
  final PlaceType? placeType;

  /// The initial icon to show in the search box
  final IconData icon;

  /// Makes available "clear textfield" button when the user is writing.
  final bool hasClearButton;

  /// The icon to show indicating the "clear textfield" button
  final IconData clearIcon;

  /// The color of the icon to show in the search box
  final Color iconColor;

  /// Enables Dark Mode when set to `true`. Default value is `false`.
  final bool darkMode;

  @override
  _SearchMapPlaceWidgetState createState() => _SearchMapPlaceWidgetState();
}

class _SearchMapPlaceWidgetState extends State<SearchMapPlaceWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late AnimationController _animationController;
  // SearchContainer height.
  late Animation _containerHeight;
  // Place options opacity.
  late Animation _listOpacity;

  List<dynamic> _placePredictions = [];
  bool _isEditing = false;
  late Geocoding geocode;

  String _tempInput = '';
  String _currentInput = '';

  final FocusNode _fn = FocusNode();

  late CrossFadeState _crossFadeState;

  @override
  void initState() {
    geocode = Geocoding(apiKey: widget.apiKey, language: widget.language);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _containerHeight = Tween<double>(begin: 48, end: 420).animate(
      CurvedAnimation(
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: const Interval(0.5, 1, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );

    _textEditingController.addListener(_autocompletePlace);
    customListener();

    if (widget.hasClearButton) {
      _fn.addListener(() async {
        if (_fn.hasFocus) {
          setState(() => _crossFadeState = CrossFadeState.showSecond);
        } else {
          setState(() => _crossFadeState = CrossFadeState.showFirst);
        }
      });
      _crossFadeState = CrossFadeState.showFirst;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _searchContainer(
          child: _searchInput(context),
        ),
      );

  /*
  WIDGETS
  */
  Widget _searchContainer({required Widget child}) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(
            color: kWhiteColor,
            height: _containerHeight.value as double?,
//            decoration: _containerDecoration(),
            child: Column(
              children: <Widget>[
                child,
                if (_placePredictions.isNotEmpty)
                  Opacity(
                    opacity: _listOpacity.value as double,
                    child: Column(
                      children: <Widget>[
                        for (final prediction in _placePredictions)
                          _placeOption(Place.fromJSON(prediction, geocode)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },);
  }

  Widget _searchInput(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CupertinoButton(
              padding: const EdgeInsets.only(left: 5, right: 10),
              onPressed: () => Get.back<void>(),
              child: Image.asset('lib/images/backarrowgray.png'),
            ),
            Image.asset('lib/images/searchico.png'),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                onSubmitted: (_) => _selectPlace(),
                onEditingComplete: _selectPlace,
                focusNode: _fn,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff606566),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.4099999964237213,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: widget.placeholder,
                  hintStyle: const TextStyle(
                    fontFamily: 'Lato',
                    color: kGrayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.4099999964237213,
                  ),
                ),
              ),
            ),
            Container(width: 15),
            if (widget.hasClearButton)
              GestureDetector(
                onTap: () {
                  if (_crossFadeState == CrossFadeState.showSecond) {
                    _textEditingController.clear();
                  }
                },
                // child: Icon(_inputIcon, color: this.widget.iconColor),
                child: AnimatedCrossFade(
                  crossFadeState: _crossFadeState,
                  duration: const Duration(milliseconds: 300),
                  firstChild: Container(),
                  secondChild: Icon(Icons.clear, color: widget.iconColor),
                ),
              ),
            if (!widget.hasClearButton) Container(),
          ],
        ),
      ),
    );
  }

  Widget _placeOption(Place prediction) {
    final place = prediction.description;

    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      onPressed: () => _selectPlace(prediction: prediction),
      child: ListTile(
        title: Text(
          place.length < 45
              ? place
              : "${place.replaceRange(45, place.length, "")} ...",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: widget.darkMode ? Colors.grey[100] : Colors.grey[850],
          ),
          maxLines: 1,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
      ),
    );
  }

  /*
  STYLING
  */
  InputDecoration _inputStyle() {
    return InputDecoration(
      hintText: widget.placeholder,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 0),
      hintStyle: TextStyle(
        color: widget.darkMode ? Colors.grey[100] : Colors.grey[850],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: widget.darkMode ? Colors.grey[800] : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 10),
      ],
    );
  }

  /*
  METHODS
  */

  /// Will be called everytime the input changes. Making callbacks to the Places
  /// Api and giving the user Place options
  Future<void> _autocompletePlace() async {
    if (_fn.hasFocus) {
      setState(() {
        _currentInput = _textEditingController.text;
        _isEditing = true;
      });

      _textEditingController.removeListener(_autocompletePlace);

      if (_currentInput.isEmpty) {
        if (!_containerHeight.isDismissed) _closeSearch();
        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      if (_currentInput == _tempInput) {
        final predictions = await _makeRequest(_currentInput);
        await _animationController.animateTo(0.5);
        setState(() => _placePredictions = predictions as List<dynamic>);
        await _animationController.forward();

        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        _textEditingController.addListener(_autocompletePlace);
        if (_isEditing == true) _autocompletePlace();
      });
    }
  }

  /// API request function. Returns the Predictions
  Future<dynamic> _makeRequest(input) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${widget.apiKey}&language=${widget.language}';
    if (widget.location != null && widget.radius != null) {
      url +=
          '&location=${widget.location!.latitude},${widget.location!.longitude}&radius=${widget.radius}';
      if (widget.strictBounds) {
        url += '&strictbounds';
      }
      if (widget.placeType != null) {
        url += '&types=${widget.placeType!.apiString}';
      }
    }

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    if (json['error_message'] != null) {
      var error = json['error_message'];
      if (error == 'This API project is not authorized to use this API.') {
        error +=
            ' Make sure the Places API is activated on your Google Cloud Platform';
      }
      throw Exception(error);
    } else {
      final predictions = json['predictions'];
      return predictions;
    }
  }

  /// Will be called when a user selects one of the Place options
  Future<void> _selectPlace({Place? prediction}) async {
    if (prediction != null) {
      _textEditingController.value = TextEditingValue(
        text: prediction.description,
        selection: TextSelection.collapsed(
          offset: prediction.description.length,
        ),
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Makes animation
    _closeSearch();

    // Calls the `onSelected` callback
    if (prediction is Place) widget.onSelected(prediction);
  }

  /// Closes the expanded search box with predictions
  Future<void> _closeSearch() async {
    if (!_animationController.isDismissed) {
      await _animationController.animateTo(0.5);
    }
    _fn.unfocus();
    setState(() {
      _placePredictions = [];
      _isEditing = false;
    });
    await _animationController.reverse();
    _textEditingController.addListener(_autocompletePlace);
  }

  /// Will listen for input changes every 0.5 seconds, allowing us to make API requests only when the user stops typing.
  void customListener() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _tempInput = _textEditingController.text);
      customListener();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    _fn.dispose();
    super.dispose();
  }
}
