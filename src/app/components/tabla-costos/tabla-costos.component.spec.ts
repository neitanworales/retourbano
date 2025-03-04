import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TablaCostosComponent } from './tabla-costos.component';

describe('TablaCostosComponent', () => {
  let component: TablaCostosComponent;
  let fixture: ComponentFixture<TablaCostosComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ TablaCostosComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(TablaCostosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
