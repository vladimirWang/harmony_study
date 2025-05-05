/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { relationalStore } from '@kit.ArkData';
import CommonConstants from '../constants/CommonConstants';
import Logger from '../utils/Logger';

export default class Rdb {
  private rdbStore: relationalStore.RdbStore | null = null;
  private tableName: string;
  private sqlCreateTable: string;
  private columns: Array<string>;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  getRdbStore(callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'getRdbStore() has no callback!');
      return;
    }
    if (this.rdbStore !== null) {
      Logger.info(CommonConstants.RDB_TAG, 'The rdbStore exists.');
      callback();
      return
    }
    let context: Context = getContext(this) as Context;
    relationalStore.getRdbStore(context, CommonConstants.STORE_CONFIG, (err, rdb) => {
      if (err) {
        Logger.error(CommonConstants.RDB_TAG, `gerRdbStore() failed, err: ${err}`);
        return;
      }
      this.rdbStore = rdb;
      this.rdbStore.executeSql(this.sqlCreateTable);
      Logger.info(CommonConstants.RDB_TAG, 'getRdbStore() finished.');
      callback();
    });
  }

  insertData(data: relationalStore.ValuesBucket): Promise<number> {
    if (this.rdbStore) {
      return this.rdbStore.insert(this.tableName, data)
    } else {
      return Promise.reject(new Error('rdbStore不存在'))
    }
  }

  deleteData(predicates: relationalStore.RdbPredicates) {
    if (this.rdbStore) {
      return this.rdbStore.delete(predicates);
    } else {
      return Promise.reject(new Error('rdbStore不存在'))
    }
  }

  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket) {
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      return this.rdbStore.update(valueBucket, predicates);
    } else {
      return Promise.reject(new Error('rdbStore不存在'))
    }
  }

  query(predicates: relationalStore.RdbPredicates) {
    if (this.rdbStore) {
      return this.rdbStore.query(predicates, this.columns);
    } else {
      return Promise.reject(new Error('rdbStore不存在'))
    }
  }
}