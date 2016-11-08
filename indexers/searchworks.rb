$:.unshift './lib'

# A sample traject configuration, save as say `traject_config.rb`, then
# run `traject -c traject_config.rb marc_file.marc` to index to
# solr specified in config file, according to rules specified in
# config file


# To have access to various built-in logic
# for pulling things out of MARC21, like `marc_languages`
require 'traject/macros/marc21_semantics'
extend  Traject::Macros::Marc21Semantics

# To have access to the traject marc format/carrier classifier
require 'traject/macros/marc_format_classifier'
extend Traject::Macros::MarcFormats


# In this case for simplicity we provide all our settings, including
# solr connection details, in this one file. But you could choose
# to separate them into antoher config file; divide things between
# files however you like, you can call traject with as many
# config files as you like, `traject -c one.rb -c two.rb -c etc.rb`
settings do
  provide "solr.url", "http://localhost:8983/solr/blacklight-core"
end

# Extract first 001, then supply code block to add "bib_" prefix to it
to_field "id", extract_marc("001a") do |record, accumulator|
  accumulator.map! do |v|
    v.sub(/^a/, '')
  end
end
to_field "marcxml", serialized_marc(:format => "xml", :binary_escape => false, :allow_oversized => true)
# TODO: marcbib_xml

to_field "all_search", extract_all_marc_values # TODO: + 024 027 028 033 905 908 920 986 979
# TODO: to_field "vern_all_search"

to_field "title_245a_search", extract_marc('245a', alternate_script: false)
to_field "vern_title_245a_search", extract_marc('245a', alternate_script: :only)

to_field "title_245_search", extract_marc('245abfgknps', alternate_script: false)
to_field "vern_title_245_search", extract_marc('245abfgknps', alternate_script: :only)

to_field "title_uniform_search", extract_marc('130adfgklmnoprst:240adfgklmnoprs', first: true, alternate_script: false)
to_field "vern_title_uniform_search", extract_marc('130adfgklmnoprst:240adfgklmnoprs', first: true, alternate_script: :only)

to_field "title_variant_search", extract_marc("210ab:222ab:242abnp:243adfgklmnoprs:246abfgnp:247abfgnp", alternate_script: false)
to_field "vern_title_variant_search", extract_marc("210ab:222ab:242abnp:243adfgklmnoprs:246abfgnp:247abfgnp", alternate_script: :only)
to_field "title_related_search", extract_marc("505t:700fgklmnoprst:710dfgklmnoprst:711fgklnpst:730adfgklmnoprst:740anp:760st:762st:765st:767st:770st:772st:773st:774st:775st:776st:777st:780st:785st:786st:787st:796fgklmnoprst:797dfgklmnoprst:798fgklnpst:799adfgklmnoprst", alternate_script: false)
to_field "vern_title_related_search", extract_marc("505t:700fgklmnoprst:710dfgklmnoprst:711fgklnpst:730adfgklmnoprst:740anp:760st:762st:765st:767st:770st:772st:773st:774st:775st:776st:777st:780st:785st:786st:787st:796fgklmnoprst:797dfgklmnoprst:798fgklnpst:799adfgklmnoprst", alternate_script: :only)
# Title Display Fields
to_field "title_245a_display", extract_marc('245a', alternate_script: false, trim_punctuation: true)
to_field "vern_title_245a_display", extract_marc('245a', alternate_script: :only, trim_punctuation: true)

to_field "title_245c_display", extract_marc('245c', alternate_script: false, trim_punctuation: true)
to_field "vern_title_245c_display", extract_marc('245c', alternate_script: :only, trim_punctuation: true)


# no sub c in title_display

to_field "title_display", extract_marc('245abdefghijklmnopqrstuvwxyz', alternate_script: false, trim_punctuation: true)
to_field "vern_title_display", extract_marc('245abdefghijklmnopqrstuvwxyz', alternate_script: :only, trim_punctuation: true)
to_field "title_full_display", extract_marc('245abcdefghijklmnopqrstuvwxyz', alternate_script: false)
to_field "vern_title_full_display", extract_marc('245abcdefghijklmnopqrstuvwxyz', alternate_script: :only)
# ? no longer will use title_uniform_display due to author-title searching needs ? 2010-11
to_field "title_uniform_display", extract_marc('130abcdefghijklmnopqrstuvwxyz:240abcdefghijklmnopqrstuvwxyz', alternate_script: false, first: true)
to_field "vern_title_uniform_display", extract_marc('130abcdefghijklmnopqrstuvwxyz:240abcdefghijklmnopqrstuvwxyz', alternate_script: :only, first: true)
# Title Sort Field
# TODO: to_field "title_sort",  custom, getSortTitle

# Series Search Fields
to_field "series_search", extract_marc("440anpv:490av:800abdefghijklmnopqrstuvwx:810abdefghijklmnopqrstuvwx:811abdefghijklmnopqrstuvwx:830abdefghijklmnopqrstuvwx", alternate_script: false)
to_field "vern_series_search", extract_marc("440anpv:490av:800abdefghijklmnopqrstuvwx:810abdefghijklmnopqrstuvwx:811abdefghijklmnopqrstuvwx:830abdefghijklmnopqrstuvwx", alternate_script: :only)
to_field "series_exact_search", extract_marc("830a", alternate_script: false)


# Author Title Search Fields
# TODO: to_field "author_title_search",  custom, getAuthorTitleSearch

# Author Search Fields
# IFF relevancy of author search needs improvement, unstemmed flavors for author search
#   (keep using stemmed version for everything search to match stemmed query)
to_field "author_1xx_search", extract_marc("100abcdgjqu:110abcdgnu:111acdegjnqu", alternate_script: false)
to_field "vern_author_1xx_search", extract_marc("100abcdgjqu:110abcdgnu:111acdegjnqu", alternate_script: :only)
to_field "author_7xx_search", extract_marc("700abcdgjqu:720ae:796abcdgjqu:710abcdgnu:797abcdgnu:711acdejngqu:798acdegjnqu", alternate_script: false)
to_field "vern_author_7xx_search", extract_marc("700abcdgjqu:720ae:796abcdgjqu:710abcdgnu:797abcdgnu:711acdegjnqu:798acdegjnqu", alternate_script: :only)
to_field "author_8xx_search", extract_marc("800abcdegjqu:810abcdegnu:811acdegjnqu", alternate_script: false)
to_field "vern_author_8xx_search", extract_marc("800abcdegjqu:810abcdegnu:811acdegjnqu", alternate_script: :only)

# Author Facet Fields
to_field "author_person_full_display", extract_marc("100800abdefghijklmnopqrstuvwxyz", alternate_script: false)
to_field "author_person_facet", extract_marc('100abcdq:700abcdq', alternate_script: false, trim_punctuation: true)
to_field "author_other_facet", extract_marc('110abcdn:111acdn:710abcdn:711acdn', alternate_script: false, trim_punctuation: true)
# Author Display Fields
to_field "author_person_display",  extract_marc('100abcdq', alternate_script: false, trim_punctuation: true)
to_field "vern_author_person_display",  extract_marc('100abcdq', alternate_script: :only, trim_punctuation: true)
to_field "author_person_full_display", extract_marc("100abdefghijklmnopqrstuvwxyz", alternate_script: false)
to_field "vern_author_person_full_display", extract_marc("100abdefghijklmnopqrstuvwxyz", alternate_script: :only)
to_field "author_corp_display", extract_marc("110abdefghijklmnopqrstuvwxyz", alternate_script: false)
to_field "vern_author_corp_display", extract_marc("110abdefghijklmnopqrstuvwxyz", alternate_script: :only)
to_field "author_meeting_display", extract_marc("111abdefghijklmnopqrstuvwxyz", alternate_script: false)
to_field "vern_author_meeting_display", extract_marc("111abdefghijklmnopqrstuvwxyz", alternate_script: :only)
# Author Sort Field
# TODO: to_field "author_sort",  custom, getSortableAuthor

# Subject Search Fields
#  should these be split into more separate fields?  Could change relevancy if match is in field with fewer terms
to_field "topic_search", extract_marc("650abcdefghijklmnopqrstu:653abcdefghijklmnopqrstu:654abcdefghijklmnopqrstu:690abcdefghijklmnopqrstu", alternate_script: false)
to_field "vern_topic_search", extract_marc("650abcdefghijklmnopqrstu:653abcdefghijklmnopqrstu:654abcdefghijklmnopqrstu:690abcdefghijklmnopqrstu", alternate_script: :only)
to_field "topic_subx_search", extract_marc("600x:610x:611x:630x:650x:651x:655x:656x:657x:690x:691x:696x:697x:698x:699x", alternate_script: false)
to_field "vern_topic_subx_search", extract_marc("600x:610x:611x:630x:650x:651x:655x:656x:657x:690x:691x:696x:697x:698x:699x", alternate_script: :only)
to_field "geographic_search", extract_marc("651abcdefghijklmnopqrstu:691abcdefghijklmnopqrstu:691abcdefghijklmnopqrstu", alternate_script: false)
to_field "vern_geographic_search", extract_marc("651abcdefghijklmnopqrstu:691abcdefghijklmnopqrstu:691abcdefghijklmnopqrstu", alternate_script: :only)
to_field "geographic_subz_search", extract_marc("600z:610z:630z:650z:651z:654z:655z:656z:657z:690z:691z:696z:697z:698z:699z", alternate_script: false)
to_field "vern_geographic_subz_search", extract_marc("600z:610z:630z:650z:651z:654z:655z:656z:657z:690z:691z:696z:697z:698z:699z", alternate_script: :only)
to_field "subject_other_search", extract_marc(%w(600 610 611 630 655 656 657 658 696 697 698 699).map { |c| "#{c}abcdefghijklmnopqrstu"}.join(':'), alternate_script: false)
to_field "vern_subject_other_search", extract_marc(%w(600 610 611 630 655 656 657 658 696 697 698 699).map { |c| "#{c}abcdefghijklmnopqrstu"}.join(':'), alternate_script: :only)
to_field "subject_other_subvy_search", extract_marc(%w(600 610 611 630 655 656 657 658 696 697 698 699).map { |c| "#{c}abcdefghijklmnopqrstuwxz"}.join(':'), alternate_script: false)
to_field "vern_subject_other_subvy_search", extract_marc(%w(600 610 611 630 655 656 657 658 696 697 698 699).map { |c| "#{c}abcdefghijklmnopqrstuwxz"}.join(':'), alternate_script: :only)
to_field "subject_all_search", extract_marc(%w(600 610 611 630 648 650 651 652 653 654 655 656 657 658 662 690 696 697 698 699).map { |c| "#{c}abcdefghijklmnopqrstuwxz"}.join(':'), alternate_script: false)
to_field "vern_subject_all_search", extract_marc(%w(600 610 611 630 648 650 651 652 653 654 655 656 657 658 662 690 696 697 698 699).map { |c| "#{c}abcdefghijklmnopqrstuvwxyz"}.join(':'), alternate_script: :only)
# Subject Facet Fields
to_field "topic_facet", extract_marc("600abcdq:600t:610ab:610t:630a:630t:650a:655a", alternate_script: false, trim_punctuation: true)
# TODO: to_field "geographic_facet", extract_marc("651a:6xxz", alternate_script: false, strip_punctuation: true)
to_field "era_facet", extract_marc("650y:651y", alternate_script: false, trim_punctuation: true)

# Publication Fields
to_field "pub_search", extract_marc("260a:264a") do |record, accumulator|
  accumulator.reject! do |v|
    Regexp.union(/s\.l\./i, /place of .* not identified/i).match(v)
  end

  accumulator.map! do |v|
    Traject::Macros::Marc21.trim_punctuation(v)
  end
end

to_field "pub_search", extract_marc("260b:264b") do |record, accumulator|
  accumulator.reject! do |v|
    Regexp.union(/s\.n\./i, /r not identified/i).match(v)
  end

  accumulator.map! do |v|
    Traject::Macros::Marc21.trim_punctuation(v)
  end
end

to_field "vern_pub_search", extract_marc("260ab:264ab", alternate_script: :only)

pub_country_008 = Traject::TranslationMap.new("pub_country_008")
to_field "pub_country", extract_marc("008[15-17]:008[15-16]", translation_map: 'pub_country_008', first: true)
# 
# # publication dates
# # deprecated
# to_field "pub_date",  custom, getPubDate
# to_field "pub_date_sort",  custom, getPubDateSort
# to_field "pub_year_tisim",  custom, getPubDateSliderVals
# # from 008 date 1
# to_field "publication_year_isi",  custom, get008Date1(est)
# to_field "beginning_year_isi",  custom, get008Date1(cdmu)
# to_field "earliest_year_isi",  custom, get008Date1(ik)
# to_field "earliest_poss_year_isi",  custom, get008Date1(q)
# to_field "release_year_isi",  custom, get008Date1(p)
# to_field "reprint_year_isi",  custom, get008Date1(r)
# to_field "other_year_isi",  custom, getOtherYear
# # from 008 date 2
# to_field "ending_year_isi",  custom, get008Date2(dm)
# to_field "latest_year_isi",  custom, get008Date2(ik)
# to_field "latest_poss_year_isi",  custom, get008Date2(q)
# to_field "production_year_isi",  custom, get008Date2(p)
# to_field "original_year_isi",  custom, get008Date2(r)
# to_field "copyright_year_isi",  custom, get008Date2(t)
# # from 260c
# to_field "imprint_display",  custom, getImprint

# # Date field for new items feed
# to_field "date_cataloged",  custom, getDateCataloged

to_field "language", marc_languages("008[35-37]:041a:041d:041e:041j")

# # old format field, left for continuity in UI URLs for old formats
# to_field "format",  custom, getOldFormats
# to_field "format_main_ssim",  custom, getMainFormats
# to_field "format_physical_ssim",  custom, getPhysicalFormats
# to_field "genre_ssim",  custom, getGenres
# 
# to_field "db_az_subject",  custom, getDbAZSubjects, db_subjects_map.properties

to_field "physical", extract_marc("300abcefg", alternate_script: false)
to_field "vern_physical", extract_marc("300abcefg", alternate_script: :only)

to_field "toc_search", extract_marc("905art:505art", alternate_script: false)
to_field "vern_toc_search", extract_marc("505art", alternate_script: :only)
to_field "context_search", extract_marc("518a", alternate_script: false)
to_field "vern_context_search", extract_marc("518a", alternate_script: :only)
to_field "summary_search", extract_marc("920ab:520ab", alternate_script: false)
to_field "vern_summary_search", extract_marc("520ab", alternate_script: :only)
to_field "award_search", extract_marc("986a:586a", alternate_script: false)

# # URL Fields
# to_field "url_fulltext",  custom, getFullTextUrls
# to_field "url_suppl",  custom, getSupplUrls
to_field "url_sfx",  extract_marc("956u") do |record, accumulator|
  accumulator.select! do |v|
    v =~ Regexp.union(%r{^(http://library.stanford.edu/sfx\\?(.+))}, %r{^(http://caslon.stanford.edu:3210/sfxlcl3\\?(.+))})
  end
end
# to_field "url_restricted",  custom, getRestrictedUrls

# Standard Number Fields
# to_field "isbn_search",  custom, getUserISBNs
# Added fields for searching based upon list from Kay Teel in JIRA ticket INDEX-142
to_field "issn_search", extract_marc("022a:022l:022m:022y:022z:400x:410x:411x:440x:490x:510x:700x:710x:711x:730x:760x:762x:765x:767x:770x:771x:772x:773x:774x:775x:776x:777x:778x:779x:780x:781x:782x:783x:784x:785x:786x:787x:788x:789x:800x:810x:811x:830x") do |record, accumulator|
  accumulator.select! do |v|
    v =~ /^(\\d{4}-\\d{3}[X\\d]\\D*)$/
  end
end
# to_field "isbn_display",  custom, getISBNs
# to_field "issn_display",  custom, getISSNs
to_field "lccn", extract_marc("010a:010z", first: true) do |record, accumulator|
  accumulator.select! do |v|
    v =~ Regexp.union(/^(([ a-z]{3}\\d{8})|([ a-z]{2}\\d{10})) ?/, %r{( /.*)?$})
  end
end
to_field "oclc", oclcnum("035a:079a")

# Call Number Fields
# to_field "callnum_facet_hsim",  custom, getCallNumHierarchVals(|, callnumber_map)
# to_field "callnum_search",  custom, getLocalCallNums
# to_field "shelfkey",  custom, getShelfkeys
# to_field "reverse_shelfkey",  custom, getReverseShelfkeys

# Location facet
# to_field "location_facet",  custom, getLocationFacet

# Item Info Fields (from 999 that aren't call number)
to_field "barcode_search", extract_marc("999i", alternate_script: false)
# to_field "preferred_barcode",  custom, getPreferredItemBarcode
# to_field "access_facet",  custom, getAccessMethods
# to_field "building_facet",  custom, getBuildings, library_map.properties
# to_field "item_display",  customDeleteRecordIfFieldEmpty, getItemDisplay

# to_field "on_order_library_ssim",  custom, getOnOrderLibraries, library_on_order_map.properties
# 
# to_field "mhld_display",  custom, getMhldDisplay
# to_field "bookplates_display",  custom, getBookplatesDisplay
# to_field "fund_facet",  custom, getFundFacet
# 
# # Digitized Items Fields
# to_field "managed_purl_urls",  custom, getManagedPurls
# to_field "collection",  custom, getCollectionDruids
# to_field "collection_with_title",  custom, getCollectionsWithTitles
# to_field "set",  custom, getSetDruids
# to_field "set_with_title",  custom, getSetsWithTitles
# to_field "collection_type",  custom, getCollectionType
# to_field "file_id",  custom, getFileId
