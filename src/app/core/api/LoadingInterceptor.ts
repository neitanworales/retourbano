import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpInterceptor } from '@angular/common/http';
import { finalize } from 'rxjs/operators';
import { LoadingService } from 'src/app/core/services/loading-screen/loading-screen.service';

@Injectable()
export class LoadingInterceptor implements HttpInterceptor {
    private totalRequests = 0;

    constructor(private loadingService: LoadingService) { }

    intercept(request: HttpRequest<any>, next: HttpHandler) {
        this.totalRequests++;
        this.loadingService.setLoading(true);

        return next.handle(request).pipe(
            finalize(() => {
                this.totalRequests--;
                if (this.totalRequests === 0) {
                    this.loadingService.setLoading(false);
                }
            })
        );
    }
}