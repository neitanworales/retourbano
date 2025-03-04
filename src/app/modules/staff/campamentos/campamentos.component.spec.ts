import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CampamentosComponent } from './campamentos.component';

describe('CampamentosComponent', () => {
  let component: CampamentosComponent;
  let fixture: ComponentFixture<CampamentosComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CampamentosComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(CampamentosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
