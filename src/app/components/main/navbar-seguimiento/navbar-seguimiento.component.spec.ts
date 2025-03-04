import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NavbarSeguimientoComponent } from './navbar-seguimiento.component';

describe('NavbarSeguimientoComponent', () => {
  let component: NavbarSeguimientoComponent;
  let fixture: ComponentFixture<NavbarSeguimientoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ NavbarSeguimientoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(NavbarSeguimientoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
