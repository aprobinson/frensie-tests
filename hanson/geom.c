//---------------------------------------------------------------------------//
//!
//! \file   geom.c
//! \author Luke Kersting
//! \brief  Geometry for Electron Au thin film verification problem
//!
//---------------------------------------------------------------------------//

void geom()
{
  // Set up manager of the geometry world
  gSystem->Load( "libGeom" );
  TGeoManager* geom = new TGeoManager(
                   "geom",
                   "Geometry for the electron Au thin film test prob.");

//---------------------------------------------------------------------------//
// Material Definitions
//---------------------------------------------------------------------------//

  // Hydrogen material
  TGeoMaterial* mat_1 = new TGeoMaterial( "mat_1", 1, 1, -19.32 );
  TGeoMedium* gold_med = new TGeoMedium( "gold_med", 2, mat_1 );

  // Void material
  TGeoMaterial* void_mat = new TGeoMaterial( "void", 0, 0, 0 );
  TGeoMedium* void_med = new TGeoMedium( "void_med", 1, void_mat );

  // Graveyard (terminal)
  TGeoMaterial* graveyard_mat = new TGeoMaterial( "graveyard", 0, 0, 0 );
  TGeoMedium* graveyard_med = new TGeoMedium( "graveyard", 3, graveyard_mat );

//---------------------------------------------------------------------------//
// Volume Definitions
//---------------------------------------------------------------------------//

  // Create the gold film
  TGeoVolume* film_volume =
    geom->MakeBox( "FILM", gold_med, .0004829, 10.0, 10.0 );

  film_volume->SetUniqueID( 1 );

  // Create the transmission tally volume
  TGeoVolume* transmission_volume =
    geom->MakeBox( "TRANSMISSION", void_med, 0.0001, 10.0, 10.0 );

  transmission_volume->SetUniqueID( 2 );

  // Create the reflection tally volume
  TGeoVolume* reflection_volume =
    geom->MakeBox( "REFLECTION", void_med, 0.0001, 10.0, 10.0 );

  reflection_volume->SetUniqueID( 3 );

  // Create the void volume
  TGeoVolume* void_volume =
    geom->MakeBox( "VOID", void_med, 1.0, 15.0, 15.0 );

  void_volume->SetUniqueID( 4 );

  // Create the graveyard volume
  TGeoVolume* graveyard_volume =
    geom->MakeBox( "GRAVEYARD", graveyard_med, 2.0, 20.0, 20.0 );

  graveyard_volume->SetUniqueID( 5 );

//---------------------------------------------------------------------------//
// Heirarchy (Volume) Definitions
//---------------------------------------------------------------------------//

  // Place the film inside of the void
  void_volume->AddNode( film_volume, 1 );

  // Place the transmission tally to the right of the film inside of the void
  void_volume->AddNode( transmission_volume, 1, new TGeoTranslation(0.000583,0.0,0.0) );

  // Place the reflection tally to the left of the film inside of the void
  void_volume->AddNode( reflection_volume, 1, new TGeoTranslation(-0.000583,0.0,0.0) );

  // Place the void inside of the graveyard
  graveyard_volume->AddNode( void_volume, 1 );

  // Set the graveyard to be the top volume (rest-of-universe)
  geom->SetTopVolume( graveyard_volume );

//---------------------------------------------------------------------------//
// Export and Drawing Capabilities
//---------------------------------------------------------------------------//

  // Close the geometry
  geom->SetTopVisible();
  geom->CloseGeometry();

  // Draw the geometry
//  void_volume->Draw();

  // Export the geometry
  geom->Export( "geom.root" );

  // Finished
  exit(0);
}

//---------------------------------------------------------------------------//
// end geom.c
//---------------------------------------------------------------------------//
