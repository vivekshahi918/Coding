import { Corn, CornExpression} from '@/nextjs/schedule';

@Injectable()

export class ArchiverService{
    @Cron(CornExpression.EVERY_DAY_AT_MIDNIGHT)
    @Cron('*/5 * * * *')

    handleArchiving(){
        console.log('Archiving old data...');
    }
}