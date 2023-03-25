program Capitulo4;

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
  X, Y: integer;
  Velocidad: integer;
var
  Evento: ALLEGRO_EVENT;
  Terminar: boolean;

  procedure iniciar();

  begin
    al_init();
    WriteLn(ALLEGRO_VERSION_INT);
    al_set_new_display_flags(ALLEGRO_WINDOWED);
    ventana := al_create_display(800, 600);
    if al_set_display_flag(ventana, ALLEGRO_OPENGL_3_0, True) then
    begin
      Writeln('No se puede usar OpenGl 3.0');
    end
    else
    begin
      Writeln('OpenGl 3.0 Activado');
    end;
    al_install_keyboard;

    ColaDeEventos := al_create_event_queue;
    //Registrar los eventos del teclado
    al_register_event_source(ColaDeEventos, al_get_keyboard_event_source);
    //Registrar los eventos de la ventana
    al_register_event_source(ColaDeEventos, al_get_display_event_source(ventana));

    al_init_image_addon(); //Inicializar extensión de imagenes
    imagen := al_load_bitmap('..' + DirectorySeparator + 'imagenes' +
      DirectorySeparator + 'soldado1.png');

    al_convert_mask_to_alpha(imagen, al_map_rgb(106, 76, 48));

    { Cargar sonido }
    al_install_audio(); //Inicializar audio
    al_init_acodec_addon(); //Inicializar extensión de codecs
    al_reserve_samples(16); //Reservar espacio para 16 sonidos

    Disparo := al_load_sample('..' + DirectorySeparator + 'sonidos' +
      DirectorySeparator + 'gun.wav');
    //Posición Inicial
    X := 0;
    Y := 0;
    Velocidad := 5;
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
    al_draw_bitmap(imagen, X, Y, 0);
    al_flip_display();
    al_clear_to_color(al_map_rgb(0, 0, 0));
  end;



  procedure ProcesarTecla();
  begin
    case Evento.keyboard.keycode of
      ALLEGRO_KEY_ESCAPE:
      begin
        terminar := True;
      end;
      ALLEGRO_KEY_ENTER:
      begin
        al_play_sample(Disparo, 1, 0, 1, ALLEGRO_PLAYMODE_ONCE, nil);
      end;
      ALLEGRO_KEY_UP:
      begin
        WriteLn(Y);
        Y := Y - 1 * Velocidad;
        if Y < (0) then
        begin
          y := 0;
        end;
        Pintar();
      end;
      ALLEGRO_KEY_DOWN:
      begin
        Y := Y + 1 * Velocidad;
        if y > 600 - al_get_bitmap_height(imagen) then
        begin
          y := 600 - al_get_bitmap_height(imagen);
        end;
        Pintar();
      end;
      ALLEGRO_KEY_LEFT:
      begin
        x := X - 1 * Velocidad;
        if X < 0 then
        begin
          x := 0;
        end;
        Pintar();
      end;
      ALLEGRO_KEY_RIGHT:
      begin
        X := X + 1 * Velocidad;
        if x > (800 - al_get_bitmap_width(imagen)) then
        begin
          x := 800 - al_get_bitmap_width(imagen);
        end;

        Pintar();
      end;
    end;
  end;

begin
  iniciar;
  Terminar := False;
  Pintar;
  repeat
    al_wait_for_event(ColaDeEventos, @Evento);

    case Evento.ftype of
      ALLEGRO_EVENT_KEY_DOWN:
      begin
        ProcesarTecla;
      end;
      ALLEGRO_EVENT_DISPLAY_SWITCH_IN:
      begin
        Pintar();
      end;
      else
      begin
        WriteLn(Evento.ftype);
      end;
    end;
  until Terminar = True;
  Finalizar();
end.
