# Test suite for get_pxweb_data()

# Below is the tests that should be conducted as a list. 
# Each listelement is a named object that contains url and dims 
# that make up the call through get_pxweb_data().
# Test will be done that downloading works, that the function returns a data.frame and that
# the size of the data.frame is test_dim, if missing values the dimension is not tested.
# in test_dim. If NA in test_dim, the dimension is ignored.

context("get_pxweb_data.R")

test_that(desc="get_pxweb_data()",{  
  
  skip_on_cran()

  api_tests_get_pxweb_data <- list(
    list(
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/PR/PR0101/PR0101E/Basbeloppet",
      dims = list(ContentsCode = c('PR0101A1'),
                  Tid = c('*')),
      clean = TRUE,
      test_dim = c(NA, 3)),
    
    list(
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy",
      dims = list(Region = c('00', '01'),
                  Civilstand = c('*'),
                  Alder = c('0', 'tot'),
                  Kon = c('*'),
                  ContentsCode = c('BE0101N1'),
                  Tid = c('2010', '2011', '2012', '2013')),
      clean = TRUE,
      test_dim = c(128, 7)),
    
    list(
      url="http://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy",
      dims = list(Region = c('00', '01'),
                  Civilstand = c('*'),
                  Alder = c('0', 'tot'),
                  Kon = c('*'),
                  ContentsCode = c('BE0101N1'),
                  Tid = c('2010', '2011', '2012', '2013')),
      clean = FALSE,
      test_dim = c(32, 8)), 
    
    list(
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/AM/AM0114/LCIArbKv",
      dims = list(SNI2007 = c('*'),
                  ContentsCode = c('*'),
                  Tid = c('*')),
      clean = FALSE,
      test_dim = c(NA, NA)),
    
    list(
      url = "http://api.scb.se/OV0104/v1/doris/en/ssd/UF/UF0536/Fullfoljt",
      dims = list(Studresultat = c('3'),
                  Kon = c('1'),
                  UtlBakgrund = c('1'),
                  Program = c('31'),
                  ContentsCode = c('UF0536A1'),
                  Tid = c('2007')),
      clean = FALSE,
      test_dim = c(NA, NA)),
    
    list(
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/MI/MI0814/MarkanvTatortZonArea",
      dims = list(Region = c('*'),
                  Kmzon = c('*'),
                  ArealStrandzon = c('*'),
                  ContentsCode = c('*'),
                  Tid = c('*')),
      clean = FALSE,
      test_dim = c(NA, NA)),
    
    list(
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/UF/UF0539/Medb30",
      dims = list(Svarsalternativ='*',
                  Kon='*',
                  Studievag='*',
                  ContentsCode='*',
                  Tid='*'),
      clean = FALSE,
      test_dim = c(NA, NA)),
    
    # Test swedish letters
    list( 
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/ME/ME0104/ME0104C/ME0104T3",
      dims = list(Region = c('*'),
                  Partimm = c('M','C','FP','KD','MP','S','V','SD','ÖVRIGA'),
                  ContentsCode = c('ME0104B7'),
                  Tid = c('2010')),
      clean = TRUE,
      test_dim = c(2907, 5)),
    
    list(
      url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/asu/asas/010_asas_tau_101.px",
      dims = list(Alue = c("*"),
                  "Asuntokunnan koko" = c("*"),
                  Talotyyppi = c("S"),
                  Vuosi = c("*")
      ),
      clean = TRUE,
      test_dim = c(2568, NA)
    )  ,
    
    list(
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/TK/TK1001/TK1001S/SnabbStatTK1001",
      dims = list("ContentsCode" = c("TK1001AE"),
                  "Tid" = c("2014M02")
      ),
      clean = TRUE
    ),
    
    list(
      url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/MI/MI0814/MarkanvTatortZonArea",
      dims = list(Region = c('*'), Kmzon = c('*'), ArealStrandzon = c('*'), ContentsCode = c('*'), Tid = c('*')
      ),
      clean = TRUE
    ),

    list(
      url = "http://api.scb.se/OV0104/v1/doris/en/ssd/BE/BE0401/BE0401A/BefolkprognRev2015",
      dims = list(Alder = c('0', '1', '2', '3', '4'),
                  Kon = c('1', '2'),
                  ContentsCode = c('0000008J'),
                  Tid = c('2015', '2016', '2017', '2018', '2019')),
      clean = FALSE,
      test_dim = c(NA, NA))  
    
  )
  
  
  for (test in api_tests_get_pxweb_data){
#    if(test$url == "http://api.scb.se/OV0104/v1/doris/en/ssd/BE/BE0401/BE0401A/BefolkprognRev2014") {
#      skip("Known error: comma bug in csv files")}

    expect_that({
      test_data <- 
        get_pxweb_data(url = test$url,
                       dims = test$dims,
                       clean = test$clean)}, 
      not(throws_error()),
      info = test$url)

    test_dim_size <- pxweb:::calculate_data_dim(pxweb:::get_dim_size(url = test$url, dims=test$dims)[[1]], test$clean)
    expect_equal(object=dim(test_data), test_dim_size, info=test$url)
    expect_equal(object=class(test_data), "data.frame", info=test$url)     
  }
})

test_that(desc="Test warnings",{  
  
  skip_on_cran()
  
  expect_that({
    test_url <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/TK/TK1001/TK1001S/SnabbStatTK1001"
    test_dims <- list("ContentsCode" = c("TK1001AE"), "Tid" = c("2014M02"))
    test_data <- 
      get_pxweb_data(url = test_url,
                     dims = test_dims,
                     clean = TRUE)}, 
    not(gives_warning()))
})