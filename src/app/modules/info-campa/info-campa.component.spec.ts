import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InfoCampaComponent } from './info-campa.component';

describe('InfoCampaComponent', () => {
  let component: InfoCampaComponent;
  let fixture: ComponentFixture<InfoCampaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ InfoCampaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(InfoCampaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
