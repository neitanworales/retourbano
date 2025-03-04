import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistroDinamicoComponent } from './registro-dinamico.component';

describe('RegistroDinamicoComponent', () => {
  let component: RegistroDinamicoComponent;
  let fixture: ComponentFixture<RegistroDinamicoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RegistroDinamicoComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RegistroDinamicoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
