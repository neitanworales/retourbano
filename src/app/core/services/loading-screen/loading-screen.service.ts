import { Injectable, OnInit } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable()
export class LoadingService implements OnInit {

  ngOnInit(): void {
    this.setLoading(false);
  }
  private isLoading$$ = new BehaviorSubject<boolean>(false);
  isLoading$ = this.isLoading$$.asObservable();
  
  setLoading(isLoading: boolean) {
    this.isLoading$$.next(isLoading);
  }
}