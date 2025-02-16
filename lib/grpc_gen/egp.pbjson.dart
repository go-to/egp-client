//
//  Generated code. Do not modify.
//  source: egp.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use categoryTypeDescriptor instead')
const CategoryType$json = {
  '1': 'CategoryType',
  '2': [
    {'1': 'CATEGORY_TYPE_NONE', '2': 0},
    {'1': 'CATEGORY_TYPE_EBISU_1', '2': 1},
    {'1': 'CATEGORY_TYPE_EBISU_2', '2': 2},
    {'1': 'CATEGORY_TYPE_EBISU_WEST', '2': 3},
    {'1': 'CATEGORY_TYPE_EBISU_SOUTH', '2': 4},
    {'1': 'CATEGORY_TYPE_BEER_COCKTAIL', '2': 5},
  ],
};

/// Descriptor for `CategoryType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List categoryTypeDescriptor = $convert.base64Decode(
    'CgxDYXRlZ29yeVR5cGUSFgoSQ0FURUdPUllfVFlQRV9OT05FEAASGQoVQ0FURUdPUllfVFlQRV'
    '9FQklTVV8xEAESGQoVQ0FURUdPUllfVFlQRV9FQklTVV8yEAISHAoYQ0FURUdPUllfVFlQRV9F'
    'QklTVV9XRVNUEAMSHQoZQ0FURUdPUllfVFlQRV9FQklTVV9TT1VUSBAEEh8KG0NBVEVHT1JZX1'
    'RZUEVfQkVFUl9DT0NLVEFJTBAF');

@$core.Deprecated('Use searchTypeDescriptor instead')
const SearchType$json = {
  '1': 'SearchType',
  '2': [
    {'1': 'SEARCH_TYPE_IN_CURRENT_SALES', '2': 0},
    {'1': 'SEARCH_TYPE_NOT_YET', '2': 1},
    {'1': 'SEARCH_TYPE_IRREGULAR_HOLIDAY', '2': 2},
    {'1': 'SEARCH_TYPE_NEEDS_RESERVATION', '2': 3},
    {'1': 'SEARCH_TYPE_BEER_COCKTAIL', '2': 4},
  ],
};

/// Descriptor for `SearchType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List searchTypeDescriptor = $convert.base64Decode(
    'CgpTZWFyY2hUeXBlEiAKHFNFQVJDSF9UWVBFX0lOX0NVUlJFTlRfU0FMRVMQABIXChNTRUFSQ0'
    'hfVFlQRV9OT1RfWUVUEAESIQodU0VBUkNIX1RZUEVfSVJSRUdVTEFSX0hPTElEQVkQAhIhCh1T'
    'RUFSQ0hfVFlQRV9ORUVEU19SRVNFUlZBVElPThADEh0KGVNFQVJDSF9UWVBFX0JFRVJfQ09DS1'
    'RBSUwQBA==');

@$core.Deprecated('Use dateDescriptor instead')
const Date$json = {
  '1': 'Date',
  '2': [
    {'1': 'year', '3': 1, '4': 1, '5': 5, '10': 'year'},
    {'1': 'month', '3': 2, '4': 1, '5': 5, '10': 'month'},
    {'1': 'day', '3': 3, '4': 1, '5': 5, '10': 'day'},
  ],
};

/// Descriptor for `Date`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateDescriptor = $convert.base64Decode(
    'CgREYXRlEhIKBHllYXIYASABKAVSBHllYXISFAoFbW9udGgYAiABKAVSBW1vbnRoEhAKA2RheR'
    'gDIAEoBVIDZGF5');

@$core.Deprecated('Use eventDescriptor instead')
const Event$json = {
  '1': 'Event',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 3, '10': 'ID'},
    {'1': 'Name', '3': 2, '4': 1, '5': 9, '10': 'Name'},
    {'1': 'Year', '3': 3, '4': 1, '5': 5, '10': 'Year'},
    {'1': 'StartDate', '3': 4, '4': 1, '5': 11, '6': '.egp.Date', '10': 'StartDate'},
    {'1': 'EndDate', '3': 5, '4': 1, '5': 11, '6': '.egp.Date', '10': 'EndDate'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode(
    'CgVFdmVudBIOCgJJRBgBIAEoA1ICSUQSEgoETmFtZRgCIAEoCVIETmFtZRISCgRZZWFyGAMgAS'
    'gFUgRZZWFyEicKCVN0YXJ0RGF0ZRgEIAEoCzIJLmVncC5EYXRlUglTdGFydERhdGUSIwoHRW5k'
    'RGF0ZRgFIAEoCzIJLmVncC5EYXRlUgdFbmREYXRl');

@$core.Deprecated('Use categoryDescriptor instead')
const Category$json = {
  '1': 'Category',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 3, '10': 'ID'},
    {'1': 'Name', '3': 2, '4': 1, '5': 9, '10': 'Name'},
  ],
};

/// Descriptor for `Category`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryDescriptor = $convert.base64Decode(
    'CghDYXRlZ29yeRIOCgJJRBgBIAEoA1ICSUQSEgoETmFtZRgCIAEoCVIETmFtZQ==');

@$core.Deprecated('Use categoriesDescriptor instead')
const Categories$json = {
  '1': 'Categories',
  '2': [
    {'1': 'Categories', '3': 1, '4': 3, '5': 11, '6': '.egp.Category', '10': 'Categories'},
  ],
};

/// Descriptor for `Categories`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoriesDescriptor = $convert.base64Decode(
    'CgpDYXRlZ29yaWVzEi0KCkNhdGVnb3JpZXMYASADKAsyDS5lZ3AuQ2F0ZWdvcnlSCkNhdGVnb3'
    'JpZXM=');

@$core.Deprecated('Use beerTypeDescriptor instead')
const BeerType$json = {
  '1': 'BeerType',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 3, '10': 'ID'},
    {'1': 'Name', '3': 2, '4': 1, '5': 9, '10': 'Name'},
  ],
};

/// Descriptor for `BeerType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List beerTypeDescriptor = $convert.base64Decode(
    'CghCZWVyVHlwZRIOCgJJRBgBIAEoA1ICSUQSEgoETmFtZRgCIAEoCVIETmFtZQ==');

@$core.Deprecated('Use beerTypesDescriptor instead')
const BeerTypes$json = {
  '1': 'BeerTypes',
  '2': [
    {'1': 'BeerTypes', '3': 1, '4': 3, '5': 11, '6': '.egp.BeerType', '10': 'BeerTypes'},
  ],
};

/// Descriptor for `BeerTypes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List beerTypesDescriptor = $convert.base64Decode(
    'CglCZWVyVHlwZXMSKwoJQmVlclR5cGVzGAEgAygLMg0uZWdwLkJlZXJUeXBlUglCZWVyVHlwZX'
    'M=');

@$core.Deprecated('Use shopDescriptor instead')
const Shop$json = {
  '1': 'Shop',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 3, '10': 'ID'},
    {'1': 'EventID', '3': 2, '4': 1, '5': 3, '10': 'EventID'},
    {'1': 'Year', '3': 34, '4': 1, '5': 5, '10': 'Year'},
    {'1': 'CategoryID', '3': 3, '4': 1, '5': 14, '6': '.egp.CategoryType', '10': 'CategoryID'},
    {'1': 'CategoryName', '3': 35, '4': 1, '5': 9, '10': 'CategoryName'},
    {'1': 'No', '3': 4, '4': 1, '5': 5, '10': 'No'},
    {'1': 'ShopName', '3': 5, '4': 1, '5': 9, '10': 'ShopName'},
    {'1': 'MenuName', '3': 6, '4': 1, '5': 9, '10': 'MenuName'},
    {'1': 'MenuImageUrl', '3': 36, '4': 1, '5': 9, '10': 'MenuImageUrl'},
    {'1': 'Phone', '3': 7, '4': 1, '5': 9, '10': 'Phone'},
    {'1': 'Address', '3': 8, '4': 1, '5': 9, '10': 'Address'},
    {'1': 'BusinessDays', '3': 9, '4': 1, '5': 9, '10': 'BusinessDays'},
    {'1': 'RegularHoliday', '3': 10, '4': 1, '5': 9, '10': 'RegularHoliday'},
    {'1': 'BusinessHours', '3': 11, '4': 1, '5': 9, '10': 'BusinessHours'},
    {'1': 'ChargePrice', '3': 12, '4': 1, '5': 9, '10': 'ChargePrice'},
    {'1': 'NormalizedChargePrice', '3': 13, '4': 1, '5': 5, '10': 'NormalizedChargePrice'},
    {'1': 'SinglePrice', '3': 14, '4': 1, '5': 9, '10': 'SinglePrice'},
    {'1': 'NormalizedSinglePrice', '3': 15, '4': 1, '5': 5, '10': 'NormalizedSinglePrice'},
    {'1': 'SetPrice', '3': 16, '4': 1, '5': 9, '10': 'SetPrice'},
    {'1': 'NormalizedSetPrice', '3': 17, '4': 1, '5': 5, '10': 'NormalizedSetPrice'},
    {'1': 'BeerType', '3': 18, '4': 1, '5': 9, '10': 'BeerType'},
    {'1': 'NeedsReservation', '3': 19, '4': 1, '5': 9, '10': 'NeedsReservation'},
    {'1': 'NormalizedNeedsReservation', '3': 20, '4': 1, '5': 8, '10': 'NormalizedNeedsReservation'},
    {'1': 'UseHachipay', '3': 21, '4': 1, '5': 9, '10': 'UseHachipay'},
    {'1': 'NormalizedUseHachipay', '3': 22, '4': 1, '5': 8, '10': 'NormalizedUseHachipay'},
    {'1': 'IsOpenHoliday', '3': 23, '4': 1, '5': 8, '10': 'IsOpenHoliday'},
    {'1': 'IsIrregularHoliday', '3': 24, '4': 1, '5': 8, '10': 'IsIrregularHoliday'},
    {'1': 'Latitude', '3': 25, '4': 1, '5': 1, '10': 'Latitude'},
    {'1': 'Longitude', '3': 26, '4': 1, '5': 1, '10': 'Longitude'},
    {'1': 'Distance', '3': 27, '4': 1, '5': 9, '10': 'Distance'},
    {'1': 'WeekNumber', '3': 28, '4': 1, '5': 5, '10': 'WeekNumber'},
    {'1': 'DayOfWeek', '3': 29, '4': 1, '5': 5, '10': 'DayOfWeek'},
    {'1': 'StartTime', '3': 30, '4': 1, '5': 9, '10': 'StartTime'},
    {'1': 'EndTime', '3': 31, '4': 1, '5': 9, '10': 'EndTime'},
    {'1': 'IsHoliday', '3': 32, '4': 1, '5': 8, '10': 'IsHoliday'},
    {'1': 'InCurrentSales', '3': 33, '4': 1, '5': 8, '10': 'InCurrentSales'},
    {'1': 'IsStamped', '3': 37, '4': 1, '5': 8, '10': 'IsStamped'},
    {'1': 'NumberOfTimes', '3': 38, '4': 1, '5': 5, '10': 'NumberOfTimes'},
  ],
};

/// Descriptor for `Shop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shopDescriptor = $convert.base64Decode(
    'CgRTaG9wEg4KAklEGAEgASgDUgJJRBIYCgdFdmVudElEGAIgASgDUgdFdmVudElEEhIKBFllYX'
    'IYIiABKAVSBFllYXISMQoKQ2F0ZWdvcnlJRBgDIAEoDjIRLmVncC5DYXRlZ29yeVR5cGVSCkNh'
    'dGVnb3J5SUQSIgoMQ2F0ZWdvcnlOYW1lGCMgASgJUgxDYXRlZ29yeU5hbWUSDgoCTm8YBCABKA'
    'VSAk5vEhoKCFNob3BOYW1lGAUgASgJUghTaG9wTmFtZRIaCghNZW51TmFtZRgGIAEoCVIITWVu'
    'dU5hbWUSIgoMTWVudUltYWdlVXJsGCQgASgJUgxNZW51SW1hZ2VVcmwSFAoFUGhvbmUYByABKA'
    'lSBVBob25lEhgKB0FkZHJlc3MYCCABKAlSB0FkZHJlc3MSIgoMQnVzaW5lc3NEYXlzGAkgASgJ'
    'UgxCdXNpbmVzc0RheXMSJgoOUmVndWxhckhvbGlkYXkYCiABKAlSDlJlZ3VsYXJIb2xpZGF5Ei'
    'QKDUJ1c2luZXNzSG91cnMYCyABKAlSDUJ1c2luZXNzSG91cnMSIAoLQ2hhcmdlUHJpY2UYDCAB'
    'KAlSC0NoYXJnZVByaWNlEjQKFU5vcm1hbGl6ZWRDaGFyZ2VQcmljZRgNIAEoBVIVTm9ybWFsaX'
    'plZENoYXJnZVByaWNlEiAKC1NpbmdsZVByaWNlGA4gASgJUgtTaW5nbGVQcmljZRI0ChVOb3Jt'
    'YWxpemVkU2luZ2xlUHJpY2UYDyABKAVSFU5vcm1hbGl6ZWRTaW5nbGVQcmljZRIaCghTZXRQcm'
    'ljZRgQIAEoCVIIU2V0UHJpY2USLgoSTm9ybWFsaXplZFNldFByaWNlGBEgASgFUhJOb3JtYWxp'
    'emVkU2V0UHJpY2USGgoIQmVlclR5cGUYEiABKAlSCEJlZXJUeXBlEioKEE5lZWRzUmVzZXJ2YX'
    'Rpb24YEyABKAlSEE5lZWRzUmVzZXJ2YXRpb24SPgoaTm9ybWFsaXplZE5lZWRzUmVzZXJ2YXRp'
    'b24YFCABKAhSGk5vcm1hbGl6ZWROZWVkc1Jlc2VydmF0aW9uEiAKC1VzZUhhY2hpcGF5GBUgAS'
    'gJUgtVc2VIYWNoaXBheRI0ChVOb3JtYWxpemVkVXNlSGFjaGlwYXkYFiABKAhSFU5vcm1hbGl6'
    'ZWRVc2VIYWNoaXBheRIkCg1Jc09wZW5Ib2xpZGF5GBcgASgIUg1Jc09wZW5Ib2xpZGF5Ei4KEk'
    'lzSXJyZWd1bGFySG9saWRheRgYIAEoCFISSXNJcnJlZ3VsYXJIb2xpZGF5EhoKCExhdGl0dWRl'
    'GBkgASgBUghMYXRpdHVkZRIcCglMb25naXR1ZGUYGiABKAFSCUxvbmdpdHVkZRIaCghEaXN0YW'
    '5jZRgbIAEoCVIIRGlzdGFuY2USHgoKV2Vla051bWJlchgcIAEoBVIKV2Vla051bWJlchIcCglE'
    'YXlPZldlZWsYHSABKAVSCURheU9mV2VlaxIcCglTdGFydFRpbWUYHiABKAlSCVN0YXJ0VGltZR'
    'IYCgdFbmRUaW1lGB8gASgJUgdFbmRUaW1lEhwKCUlzSG9saWRheRggIAEoCFIJSXNIb2xpZGF5'
    'EiYKDkluQ3VycmVudFNhbGVzGCEgASgIUg5JbkN1cnJlbnRTYWxlcxIcCglJc1N0YW1wZWQYJS'
    'ABKAhSCUlzU3RhbXBlZBIkCg1OdW1iZXJPZlRpbWVzGCYgASgFUg1OdW1iZXJPZlRpbWVz');

@$core.Deprecated('Use shopLocationDescriptor instead')
const ShopLocation$json = {
  '1': 'ShopLocation',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 3, '10': 'ID'},
    {'1': 'ShopID', '3': 2, '4': 1, '5': 3, '10': 'ShopID'},
    {'1': 'Latitude', '3': 3, '4': 1, '5': 1, '10': 'Latitude'},
    {'1': 'Longitude', '3': 4, '4': 1, '5': 1, '10': 'Longitude'},
    {'1': 'Location', '3': 5, '4': 1, '5': 9, '10': 'Location'},
  ],
};

/// Descriptor for `ShopLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shopLocationDescriptor = $convert.base64Decode(
    'CgxTaG9wTG9jYXRpb24SDgoCSUQYASABKANSAklEEhYKBlNob3BJRBgCIAEoA1IGU2hvcElEEh'
    'oKCExhdGl0dWRlGAMgASgBUghMYXRpdHVkZRIcCglMb25naXR1ZGUYBCABKAFSCUxvbmdpdHVk'
    'ZRIaCghMb2NhdGlvbhgFIAEoCVIITG9jYXRpb24=');

@$core.Deprecated('Use shopTimeDescriptor instead')
const ShopTime$json = {
  '1': 'ShopTime',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 3, '10': 'ID'},
    {'1': 'ShopID', '3': 2, '4': 1, '5': 3, '10': 'ShopID'},
    {'1': 'WeekNumber', '3': 3, '4': 1, '5': 5, '10': 'WeekNumber'},
    {'1': 'DayOfWeek', '3': 4, '4': 1, '5': 5, '10': 'DayOfWeek'},
    {'1': 'StartTime', '3': 5, '4': 1, '5': 9, '10': 'StartTime'},
    {'1': 'EndTime', '3': 6, '4': 1, '5': 9, '10': 'EndTime'},
    {'1': 'IsHoliday', '3': 7, '4': 1, '5': 8, '10': 'IsHoliday'},
  ],
};

/// Descriptor for `ShopTime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shopTimeDescriptor = $convert.base64Decode(
    'CghTaG9wVGltZRIOCgJJRBgBIAEoA1ICSUQSFgoGU2hvcElEGAIgASgDUgZTaG9wSUQSHgoKV2'
    'Vla051bWJlchgDIAEoBVIKV2Vla051bWJlchIcCglEYXlPZldlZWsYBCABKAVSCURheU9mV2Vl'
    'axIcCglTdGFydFRpbWUYBSABKAlSCVN0YXJ0VGltZRIYCgdFbmRUaW1lGAYgASgJUgdFbmRUaW'
    '1lEhwKCUlzSG9saWRheRgHIAEoCFIJSXNIb2xpZGF5');

@$core.Deprecated('Use shopsRequestDescriptor instead')
const ShopsRequest$json = {
  '1': 'ShopsRequest',
  '2': [
    {'1': 'SearchTypes', '3': 1, '4': 3, '5': 14, '6': '.egp.SearchType', '10': 'SearchTypes'},
    {'1': 'UserId', '3': 2, '4': 1, '5': 9, '10': 'UserId'},
  ],
};

/// Descriptor for `ShopsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shopsRequestDescriptor = $convert.base64Decode(
    'CgxTaG9wc1JlcXVlc3QSMQoLU2VhcmNoVHlwZXMYASADKA4yDy5lZ3AuU2VhcmNoVHlwZVILU2'
    'VhcmNoVHlwZXMSFgoGVXNlcklkGAIgASgJUgZVc2VySWQ=');

@$core.Deprecated('Use shopsResponseDescriptor instead')
const ShopsResponse$json = {
  '1': 'ShopsResponse',
  '2': [
    {'1': 'Shops', '3': 1, '4': 3, '5': 11, '6': '.egp.Shop', '10': 'Shops'},
  ],
};

/// Descriptor for `ShopsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shopsResponseDescriptor = $convert.base64Decode(
    'Cg1TaG9wc1Jlc3BvbnNlEh8KBVNob3BzGAEgAygLMgkuZWdwLlNob3BSBVNob3Bz');

@$core.Deprecated('Use addStampRequestDescriptor instead')
const AddStampRequest$json = {
  '1': 'AddStampRequest',
  '2': [
    {'1': 'UserId', '3': 1, '4': 1, '5': 9, '10': 'UserId'},
    {'1': 'ShopId', '3': 2, '4': 1, '5': 3, '10': 'ShopId'},
  ],
};

/// Descriptor for `AddStampRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addStampRequestDescriptor = $convert.base64Decode(
    'Cg9BZGRTdGFtcFJlcXVlc3QSFgoGVXNlcklkGAEgASgJUgZVc2VySWQSFgoGU2hvcElkGAIgAS'
    'gDUgZTaG9wSWQ=');

@$core.Deprecated('Use addStampResponseDescriptor instead')
const AddStampResponse$json = {
  '1': 'AddStampResponse',
  '2': [
    {'1': 'NumberOfTimes', '3': 1, '4': 1, '5': 5, '10': 'NumberOfTimes'},
  ],
};

/// Descriptor for `AddStampResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addStampResponseDescriptor = $convert.base64Decode(
    'ChBBZGRTdGFtcFJlc3BvbnNlEiQKDU51bWJlck9mVGltZXMYASABKAVSDU51bWJlck9mVGltZX'
    'M=');

@$core.Deprecated('Use deleteStampRequestDescriptor instead')
const DeleteStampRequest$json = {
  '1': 'DeleteStampRequest',
  '2': [
    {'1': 'UserId', '3': 1, '4': 1, '5': 9, '10': 'UserId'},
    {'1': 'ShopId', '3': 2, '4': 1, '5': 3, '10': 'ShopId'},
  ],
};

/// Descriptor for `DeleteStampRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteStampRequestDescriptor = $convert.base64Decode(
    'ChJEZWxldGVTdGFtcFJlcXVlc3QSFgoGVXNlcklkGAEgASgJUgZVc2VySWQSFgoGU2hvcElkGA'
    'IgASgDUgZTaG9wSWQ=');

@$core.Deprecated('Use deleteStampResponseDescriptor instead')
const DeleteStampResponse$json = {
  '1': 'DeleteStampResponse',
  '2': [
    {'1': 'NumberOfTimes', '3': 1, '4': 1, '5': 5, '10': 'NumberOfTimes'},
  ],
};

/// Descriptor for `DeleteStampResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteStampResponseDescriptor = $convert.base64Decode(
    'ChNEZWxldGVTdGFtcFJlc3BvbnNlEiQKDU51bWJlck9mVGltZXMYASABKAVSDU51bWJlck9mVG'
    'ltZXM=');

