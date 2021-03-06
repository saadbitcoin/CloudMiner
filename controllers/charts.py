# coding: utf8
import operator

#@auth.requires_login()
def index(): return dict(message=T('Hello World'))

#@auth.requires_login()
def data():
    query  = (db.machine)
    count  = db.machine.id.count()
    result = db(query).select(db.machine.name, count, groupby=db.machine.id)

    tlist = []
    for item in result:
        elem = {}
        elem['count'] = item[count]    # <-- note the syntax
        elem['name'] = item.machine.name
        tlist.append(elem)

    return dict(rows = tlist)

#@auth.requires_login()
def data1():
    query  = (db.worker_stats.worker_id == 50)
    result =  db(query).select(db.worker_stats.timestamp, db.worker_stats.hash_rate)
    return dict(rows = result)

def grouped_hashes_data():
    rows1 = db(db.currency).select(db.currency.name)
    i = 0
    dict1 = {}
    list_currencies = []
    for row1 in rows1:
        cur_name = row1['name']
        if cur_name == 'BitCoin':
            factor = 1
            unit = ' (MH/s)'
        else:
            factor = 1000
            unit = ' (KH/s)'
        list_currencies.append((cur_name,factor,unit))
        #query = 'SELECT timestamp, unix_timestamp(timestamp) timestamp_unix, SUM(hash_rate) hash_sum FROM (SELECT DATE_ADD(ws1.timestamp, INTERVAL -(second(time(ws1.timestamp)) - (second(time(ws1.timestamp)) DIV 60 * 60)) second) timestamp, ws1.hash_rate FROM currency c, miner m, worker w, worker_stats ws1 WHERE (w.time_stop IS NULL OR w.time_stop>NOW()) AND ws1.worker_id = w.id AND m.id = w.miner_id AND c.id = m.currency_id AND ws1.hash_avg != 0 AND c.name = \''+ cur_name + '\' AND ws1.timestamp BETWEEN \'2014-06-30 20:10:00\' AND NOW()) t1 GROUP BY timestamp'
        query = 'SELECT timestamp1 timestamp, unix_timestamp(timestamp) timestamp_unix, SUM(hash_rate) hash_sum FROM (SELECT timestamp, DATE_ADD(ws1.timestamp, INTERVAL -(second(time(ws1.timestamp)) - (second(time(ws1.timestamp)) DIV 60 * 60)) second) timestamp1, ws1.hash_rate FROM currency c, miner m, worker w, worker_stats ws1 WHERE (w.time_stop IS NULL OR w.time_stop>NOW()) AND ws1.worker_id = w.id AND m.id = w.miner_id AND c.id = m.currency_id AND ws1.hash_avg != 0 AND c.name = \''+ cur_name + '\' AND ws1.timestamp BETWEEN \'2014-06-30 20:15:00\' AND \'2014-06-30 20:50:00\') t1 WHERE ABS(timestamp1 - timestamp) < 5 GROUP BY timestamp'
        rows2 = db.executesql(query, as_dict=True)
        #print query
        for row2 in rows2:
            key = str(row2['timestamp'])
            if key in dict1.keys():
                #print 'entra!'
                inner_list = dict1[key][1]
            else:
                inner_list = []
                for j in range(4):
                    inner_list.append(0)
            inner_list[i] = row2['hash_sum'] 
            dict1[key] = (row2['timestamp_unix'],inner_list)
            #dict1[key] = row['timestamp_unix']
        sorted_list1 = sorted(dict1.iteritems(), key=operator.itemgetter(1))
        list_def = []
        for item in sorted_list1:
            item_def = {}
            item_def['time'] = item[0]
            k = 0
            for cur_tuple in list_currencies:
                currency = cur_tuple[0]
                factor = cur_tuple[1]
                unit = cur_tuple[2]
                '''if item['hash_rate'] >= 1000:
                    rate = item['hash_rate'] / 1000
                    unit = 'GH/s'
                elif item['hash_rate'] > 0.1:
                    rate = item['hash_rate']
                    unit = 'MH/s'
                else :
                    rate = item['hash_rate'] * 1000
                    unit = 'KH/s'
                tlist.append(str(round(rate,2)) + ' ' + unit)'''
                hashes = round(item[1][1][k]*factor,2)
                #item_def[currency+unit] = hashes
                item_def[currency] = hashes
                k += 1
            list_def.append(item_def)
        i = i + 1
    return dict(rows=list_def)
    #return dict(sorted_dict1=sorted_dict1) 
    #return dict(rows=rows1)
