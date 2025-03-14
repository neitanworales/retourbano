import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReinscripcionComponent } from './reinscripcion.component';

describe('ReinscripcionComponent', () => {
  let component: ReinscripcionComponent;
  let fixture: ComponentFixture<ReinscripcionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ReinscripcionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ReinscripcionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
