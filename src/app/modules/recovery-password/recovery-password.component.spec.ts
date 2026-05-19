import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';
import { of } from 'rxjs';

import { RecoveryPasswordComponent } from './recovery-password.component';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';

describe('RecoveryPasswordComponent', () => {
  let component: RecoveryPasswordComponent;
  let fixture: ComponentFixture<RecoveryPasswordComponent>;

  beforeEach(async () => {
    const loginDaoMock = {
      validateResetToken: () => of({ success: true }),
      resetPassword: () => of({ success: true })
    };

    await TestBed.configureTestingModule({
      declarations: [ RecoveryPasswordComponent ],
      imports: [ReactiveFormsModule, RouterTestingModule],
      providers: [
        { provide: LoginDao, useValue: loginDaoMock },
        {
          provide: ActivatedRoute,
          useValue: {
            snapshot: {
              queryParamMap: {
                get: () => 'token-prueba'
              }
            }
          }
        }
      ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RecoveryPasswordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
