import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FooterSeguimientoComponent } from './footer-seguimiento.component';

describe('FooterSeguimientoComponent', () => {
  let component: FooterSeguimientoComponent;
  let fixture: ComponentFixture<FooterSeguimientoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ FooterSeguimientoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(FooterSeguimientoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
