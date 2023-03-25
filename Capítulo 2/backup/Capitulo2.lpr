program Capitulo2;

uses
  Allegro5,
  Al5image;

var
  ventana: ALLEGRO_DISPLAYptr;
  ColaDeEventos: ALLEGRO_EVENT_QUEUEptr;
  imagen: ALLEGRO_BITMAPptr;

  procedure iniciar();
  begin
    al_init();
    al_set_new_display_flags(ALLEGRO_WINDOWED);
    ventana := al_create_display(800, 600);
    al_install_keyboard;
    ColaDeEventos := al_create_event_queue;
    al_register_event_source(ColaDeEventos, al_get_keyboard_event_source);
     al_init_image_addon();
    imagen := al_load_bitmap('..' + DirectorySeparator + 'imagenes' +
      DirectorySeparator + 'soldado1.png');
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

  end;

  procedure Pintar()
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
        Terminar := True;
    end;
  until Terminar = True;
  Finalizar();
end.
