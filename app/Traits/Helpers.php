<?php

namespace App\Traits;

use App\Models\Setting;
use Illuminate\Database\Eloquent\Model;

trait Helpers
{

    /**
     * @param mixed $key
     *
     * @return bool
     */
    function auditable($key)
    {
        return json_decode(cache()->remember('settings', 60 * 60 * 2, function () {
            return Setting::where('name', 'general')->first();
        })->settings)->saveUpdates->$key[1];
    }

    /**
     * @param object|array $before
     * @param object|array $after
     * @param string $classModel
     * @param array $columns
     * @param array $arraySave
     *
     * @return void
     */
    function saveUpdates(object|array $before, object|array $after, string $classModel, array $columns, array $arraySave = []): void
    {
        $model = new $classModel;
        $b = is_array($before) ? $before['id'] : $before->id;
        if ($model instanceof Model && $after->id === $b) {
            $m = $model->find($after->id);
            if ($m) {
                $m->update(
                    [
                        'updates' => array_merge_recursive(
                            json_decode(
                                $m->updates,
                                true
                            ),
                            [
                                'user_id' => auth()->id(),
                            ],
                            $this->resetValue(collect($after)->only($columns)->all(), $arraySave)
                        ),
                        'updated_at' => now()
                    ]
                );
            } else {
                $model->create([
                    'id' => $after->id,
                    'updates' => $this->checkIfHasArray($before, collect($after)->only($columns)->all(), $columns, $arraySave),
                    'updated_at' => now()
                ]);
            }
        }
    }

    /**
     * @param mixed $before
     * @param mixed $after
     * @param mixed $columns
     * @param mixed $arraySave
     *
     * @return [type]
     */
    function checkIfHasArray($before, $after, $columns, $arraySave)
    {

        $before = $this->resetValue($before, $arraySave);
        $after = $this->resetValue($after, $arraySave);
        return json_encode(
            array_merge_recursive(
                [
                    'user_id' => 0,
                ],
                [
                    'user_id' => auth()->id(),
                ],
                !is_array($before) ? collect($before->toArray())->only($columns)->all() : collect($before)->only($columns)->all(),
                $after
            )
        );
    }

    /**
     * @param mixed $array
     * @param mixed $arraySave
     *
     * @return mixed [type]
     */
    function resetValue($array, $arraySave): mixed
    {
        foreach ($array as $k => $b) {
            if (in_array($k, $arraySave) && is_array($b)) {
                $array[$k] = [$array[$k]];
            }
        }
        return $array;
    }

    /**
     * @param $date
     * @param $time
     * @return bool
     */
    function validateDate($date, $time): bool
    {
        return preg_replace('/\D/', '', $date . ' ' . $time) > preg_replace('/\D/', '', now()->format('H:i:s'));
    }
}
