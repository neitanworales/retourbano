import { ComponentFixture, TestBed } from '@angular/core/testing';

import { QueTraerComponent } from './que-traer.component';

describe('QueTraerComponent', () => {
  let component: QueTraerComponent;
  let fixture: ComponentFixture<QueTraerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [QueTraerComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(QueTraerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
