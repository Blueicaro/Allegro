program Capitulo3;

uses
  Allegro5,
  Al5image,
  al5audio,
  al5acodec,
  al5Base,
  SysUtils;

var
  ventana: ALLEGRO_DISPLAYptr;
  ColaDeEventos: ALLEGRO_EVENT_QUEUEptr;
  imagen: ALLEGRO_BITMAPptr;
  Disparo: ALLEGRO_SAMPLEptr;

  procedure iniciar();

  begin
    al_init();
    al_set_new_display_flags(ALLEGRO_WINDOWED);
    ventana := al_create_display(800, 600);
    al_install_keyboard;
    ColaDeEventos := al_create_event_queue;
    al_register_event_source(ColaDeEventos, al_get_keyboard_event_source);

    al_init_image_addon(); //Inicializar extensión de imagenes
    imagen := al_load_bitmap('..' + DirectorySeparator + 'imagenes' +
      DirectorySeparator + 'soldado1.png');


    { Cargar sonido }
    al_install_audio(); //Inicializar audio
    al_init_acodec_addon(); //Inicializar extensión de codecs
    al_reserve_samples(16); //Reservar espacio para 16 sonidos

    Disparo := al_load_sample('..' + DirectorySeparator + 'sonidos' +
      DirectorySeparator + 'gun.wav');

  end;

  procedure Finalizar();
  begin
    if Assigned(ColaDeEventos) then
    begin
      al_destroy_event_queue(ColaDeEventos);
      ColaDeEventos := nil;
    end;
    if Assigned(ventana) then
    begin
      al_destroy_display(ventana);
      ventana := nil;
    end;

    if Assigned(imagen) then
    begin
      al_destroy_bitmap(Imagen);
    end;

    if Assigned(Disparo) then
    begin
      al_destroy_sample(Disparo);
    end;

  end;

  procedure Pintar();
  begin
    al_draw_bitmap(imagen, 100, 100, 0);
    al_flip_display();
  end;

var
  Evento: ALLEGRO_EVENT;
  Terminar: boolean;
begin
  iniciar;
  Terminar := False;
  Pintar;
  repeat
    al_wait_for_event(ColaDeEventos, @Evento);
    case Evento.ftype of
      ALLEGRO_EVENT_KEY_DOWN:
      begin
        if Evento.keyboard.keycode = ALLEGRO_KEY_ESCAPE then
        begin
          Terminar := True;
        end;
        if Evento.keyboard.keycode = ALLEGRO_KEY_ENTER then
        begin
          al_play_sample(Disparo, 1, 0, 1, ALLEGRO_PLAYMODE_ONCE, nil);
        end;


      end;
    end;
  until Terminar = True;
  Finalizar();
end.
